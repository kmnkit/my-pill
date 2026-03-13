const { onCall, HttpsError } = require('firebase-functions/v2/https');
const { onSchedule } = require('firebase-functions/v2/scheduler');
const admin = require('firebase-admin');
const crypto = require('crypto');
admin.initializeApp();

const db = admin.firestore();

async function deleteDocs(docs) {
  for (let i = 0; i < docs.length; i += 500) {
    const batch = db.batch();
    docs.slice(i, i + 500).forEach(doc => batch.delete(doc.ref));
    await batch.commit();
  }
}

// Rate limiter: max N calls per minute per uid+action
async function checkRateLimit(uid, action, maxPerMinute = 5) {
  const now = Date.now();
  const windowStart = now - 60000; // 1 minute window
  const rateLimitRef = db.collection('rateLimits').doc(`${uid}_${action}`);

  await db.runTransaction(async (transaction) => {
    const doc = await transaction.get(rateLimitRef);
    const timestamps = doc.exists ? (doc.data().timestamps || []) : [];
    const recentCalls = timestamps.filter(t => t > windowStart);
    if (recentCalls.length >= maxPerMinute) {
      throw new HttpsError('resource-exhausted', 'Too many requests. Please try again later.');
    }
    recentCalls.push(now);
    transaction.set(rateLimitRef, { timestamps: recentCalls, updatedAt: admin.firestore.FieldValue.serverTimestamp() });
  });
}

// Generate invite link
exports.generateInviteLink = onCall(async (request) => {
  if (!request.auth) throw new HttpsError('unauthenticated', 'Must be signed in');

  await checkRateLimit(request.auth.uid, 'generateInviteLink');

  const patientId = request.auth.uid;
  const code = generateCode();

  await db.collection('invites').doc(code).set({
    patientId,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7 days
    status: 'pending',
  });

  return { url: `https://kusuridoki.app/invite/${code}`, code };
});

// Accept invite
exports.acceptInvite = onCall(async (request) => {
  if (!request.auth) throw new HttpsError('unauthenticated', 'Must be signed in');

  await checkRateLimit(request.auth.uid, 'acceptInvite');

  const { code } = request.data;
  const caregiverId = request.auth.uid;

  const inviteRef = db.collection('invites').doc(code);
  const invite = await inviteRef.get();

  if (!invite.exists) throw new HttpsError('not-found', 'Invalid invite code');

  const inviteData = invite.data();
  if (inviteData.status !== 'pending') throw new HttpsError('failed-precondition', 'Invite already used');
  if (inviteData.expiresAt.toDate() < new Date()) throw new HttpsError('failed-precondition', 'Invite expired');

  const patientId = inviteData.patientId;

  // Prevent self-invitation
  if (caregiverId === patientId) {
    throw new HttpsError('invalid-argument', 'Cannot accept your own invite');
  }

  // Read patient profile to get name for caregiver dashboard
  const patientDoc = await db.collection('users').doc(patientId).get();
  const patientData = patientDoc.exists ? patientDoc.data() : {};
  const patientName = patientData?.profile?.name || 'Patient';

  // Prevent duplicate caregiver-patient link
  const existingLink = await db.collection('caregiverAccess').doc(caregiverId).collection('patients').doc(patientId).get();
  if (existingLink.exists) {
    throw new HttpsError('already-exists', 'Already linked to this patient');
  }

  const batch = db.batch();

  // Create caregiver access (with patient name for dashboard display)
  batch.set(db.collection('caregiverAccess').doc(caregiverId).collection('patients').doc(patientId), {
    patientId,
    patientName,
    linkedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  // Create caregiver link on patient side
  const linkId = db.collection('users').doc(patientId).collection('caregiverLinks').doc().id;
  batch.set(db.collection('users').doc(patientId).collection('caregiverLinks').doc(linkId), {
    id: linkId,
    patientId,
    caregiverId,
    caregiverName: request.auth.token.name || 'Caregiver',
    status: 'connected',
    linkedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  // Mark invite as used
  batch.update(inviteRef, { status: 'accepted', acceptedBy: caregiverId });

  await batch.commit();
  return { success: true, patientId };
});

// Revoke access
exports.revokeAccess = onCall(async (request) => {
  if (!request.auth) throw new HttpsError('unauthenticated', 'Must be signed in');

  await checkRateLimit(request.auth.uid, 'revokeAccess', 5);

  const { caregiverId, linkId } = request.data;
  const patientId = request.auth.uid;

  // Verify link belongs to this patient
  const linkDoc = await db.collection('users').doc(patientId).collection('caregiverLinks').doc(linkId).get();
  if (!linkDoc.exists) {
    throw new HttpsError('not-found', 'Caregiver link not found');
  }
  if (linkDoc.data().caregiverId !== caregiverId) {
    throw new HttpsError('permission-denied', 'Caregiver ID mismatch');
  }

  const batch = db.batch();
  batch.delete(db.collection('caregiverAccess').doc(caregiverId).collection('patients').doc(patientId));
  batch.delete(db.collection('users').doc(patientId).collection('caregiverLinks').doc(linkId));
  await batch.commit();

  return { success: true };
});

// Delete user account — server-side cleanup of all user data + auth
exports.deleteUserAccount = onCall(async (request) => {
  if (!request.auth) throw new HttpsError('unauthenticated', 'Must be signed in');

  await checkRateLimit(request.auth.uid, 'deleteUserAccount', 3);

  const uid = request.auth.uid;

  // Delete all subcollections under users/{uid}
  const subcollections = ['medications', 'schedules', 'reminders', 'adherenceRecords', 'caregiverLinks'];
  for (const col of subcollections) {
    const snapshot = await db.collection('users').doc(uid).collection(col).get();
    await deleteDocs(snapshot.docs);
  }

  // Delete caregiverAccess docs where this user is a caregiver
  const caregiverPatientsSnapshot = await db.collection('caregiverAccess').doc(uid).collection('patients').get();
  await deleteDocs(caregiverPatientsSnapshot.docs);
  // Also delete the caregiverAccess/{uid} parent doc if it exists
  await db.collection('caregiverAccess').doc(uid).delete().catch(() => {});

  // Delete caregiverAccess docs where this user is a PATIENT (collectionGroup query)
  const patientLinksSnapshot = await db.collectionGroup('patients')
    .where('patientId', '==', uid)
    .get();
  await deleteDocs(patientLinksSnapshot.docs);

  // Delete pending invites created by this user
  const pendingInvites = await db.collection('invites')
    .where('patientId', '==', uid)
    .get();
  await deleteDocs(pendingInvites.docs);

  // Delete rate limit documents for this user
  const rateLimitIds = [
    `${uid}_generateInviteLink`,
    `${uid}_acceptInvite`,
    `${uid}_revokeAccess`,
    `${uid}_deleteUserAccount`,
  ];
  const rateLimitBatch = db.batch();
  for (const id of rateLimitIds) {
    rateLimitBatch.delete(db.collection('rateLimits').doc(id));
  }
  await rateLimitBatch.commit();

  // Delete the user document
  await db.collection('users').doc(uid).delete();

  // Delete the Firebase Auth account
  await admin.auth().deleteUser(uid);

  return { success: true };
});

// Scheduled cleanup of expired invites (runs daily)
exports.cleanupExpiredInvites = onSchedule('every 24 hours', async () => {
  const now = new Date();
  const expired = await db.collection('invites')
    .where('expiresAt', '<', now)
    .where('status', '==', 'pending')
    .get();

  await deleteDocs(expired.docs);

  console.log(`Cleaned up ${expired.size} expired invites`);
});

// Verify IAP receipt and store subscription status server-side
exports.verifyReceipt = onCall(async (request) => {
  if (!request.auth) throw new HttpsError('unauthenticated', 'Must be signed in');

  await checkRateLimit(request.auth.uid, 'verifyReceipt', 5);

  const { productId, purchaseToken, source } = request.data;

  if (!productId || typeof productId !== 'string') {
    throw new HttpsError('invalid-argument', 'productId is required');
  }
  if (!purchaseToken || typeof purchaseToken !== 'string') {
    throw new HttpsError('invalid-argument', 'purchaseToken is required');
  }
  if (!source || !['app_store', 'google_play'].includes(source)) {
    throw new HttpsError('invalid-argument', 'source must be app_store or google_play');
  }

  const uid = request.auth.uid;

  // Store receipt data for server-side verification
  const existingReceipt = await db.collection('users').doc(uid).collection('subscriptions').doc(purchaseToken).get();
  if (existingReceipt.exists) {
    return { success: true, status: existingReceipt.data().status };
  }
  await db.collection('users').doc(uid).collection('subscriptions').doc(purchaseToken).set({
    productId,
    purchaseToken,
    source,
    verifiedAt: admin.firestore.FieldValue.serverTimestamp(),
    status: 'pending_verification',
  });

  // Mark as pending — do NOT grant premium until receipt is verified
  await db.collection('users').doc(uid).update({
    premiumPending: true,
    premiumProductId: productId,
    premiumUpdatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  return { success: true, status: 'pending_verification' };
});

function generateCode() {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789';
  const bytes = crypto.randomBytes(8);
  let code = '';
  for (let i = 0; i < 8; i++) {
    code += chars.charAt(bytes[i] % chars.length);
  }
  return code;
}
