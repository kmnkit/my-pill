const functions = require('firebase-functions');
const admin = require('firebase-admin');
const crypto = require('crypto');
admin.initializeApp();

const db = admin.firestore();

// Rate limiter: max 5 calls per minute per uid+action
async function checkRateLimit(uid, action, maxPerMinute = 5) {
  const now = Date.now();
  const windowStart = now - 60000; // 1 minute window
  const rateLimitRef = db.collection('rateLimits').doc(`${uid}_${action}`);

  const doc = await rateLimitRef.get();
  if (doc.exists) {
    const data = doc.data();
    const recentCalls = (data.timestamps || []).filter(t => t > windowStart);
    if (recentCalls.length >= maxPerMinute) {
      throw new functions.https.HttpsError('resource-exhausted', 'Too many requests. Please try again later.');
    }
    recentCalls.push(now);
    await rateLimitRef.set({ timestamps: recentCalls, updatedAt: admin.firestore.FieldValue.serverTimestamp() });
  } else {
    await rateLimitRef.set({ timestamps: [now], updatedAt: admin.firestore.FieldValue.serverTimestamp() });
  }
}

// Generate invite link
exports.generateInviteLink = functions.https.onCall(async (data, context) => {
  if (!context.auth) throw new functions.https.HttpsError('unauthenticated', 'Must be signed in');

  await checkRateLimit(context.auth.uid, 'generateInviteLink');

  const patientId = context.auth.uid;
  const code = generateCode();

  await db.collection('invites').doc(code).set({
    patientId,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7 days
    status: 'pending',
  });

  return { url: `https://mypill.app/invite/${code}`, code };
});

// Accept invite
exports.acceptInvite = functions.https.onCall(async (data, context) => {
  if (!context.auth) throw new functions.https.HttpsError('unauthenticated', 'Must be signed in');

  await checkRateLimit(context.auth.uid, 'acceptInvite');

  const { code } = data;
  const caregiverId = context.auth.uid;

  const inviteRef = db.collection('invites').doc(code);
  const invite = await inviteRef.get();

  if (!invite.exists) throw new functions.https.HttpsError('not-found', 'Invalid invite code');

  const inviteData = invite.data();
  if (inviteData.status !== 'pending') throw new functions.https.HttpsError('failed-precondition', 'Invite already used');
  if (inviteData.expiresAt.toDate() < new Date()) throw new functions.https.HttpsError('failed-precondition', 'Invite expired');

  const patientId = inviteData.patientId;

  // Prevent self-invitation
  if (caregiverId === patientId) {
    throw new functions.https.HttpsError('invalid-argument', 'Cannot accept your own invite');
  }

  // Read patient profile to get name for caregiver dashboard
  const patientDoc = await db.collection('users').doc(patientId).get();
  const patientData = patientDoc.exists ? patientDoc.data() : {};
  const patientName = patientData?.profile?.name || 'Patient';

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
    caregiverName: context.auth.token.name || 'Caregiver',
    status: 'connected',
    linkedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  // Mark invite as used
  batch.update(inviteRef, { status: 'accepted', acceptedBy: caregiverId });

  await batch.commit();
  return { success: true, patientId };
});

// Revoke access
exports.revokeAccess = functions.https.onCall(async (data, context) => {
  if (!context.auth) throw new functions.https.HttpsError('unauthenticated', 'Must be signed in');

  await checkRateLimit(context.auth.uid, 'revokeAccess', 5);

  const { caregiverId, linkId } = data;
  const patientId = context.auth.uid;

  // Verify link belongs to this patient
  const linkDoc = await db.collection('users').doc(patientId).collection('caregiverLinks').doc(linkId).get();
  if (!linkDoc.exists) {
    throw new functions.https.HttpsError('not-found', 'Caregiver link not found');
  }

  const batch = db.batch();
  batch.delete(db.collection('caregiverAccess').doc(caregiverId).collection('patients').doc(patientId));
  batch.delete(db.collection('users').doc(patientId).collection('caregiverLinks').doc(linkId));
  await batch.commit();

  return { success: true };
});

// Delete user account — server-side cleanup of all user data + auth
exports.deleteUserAccount = functions.https.onCall(async (data, context) => {
  if (!context.auth) throw new functions.https.HttpsError('unauthenticated', 'Must be signed in');

  await checkRateLimit(context.auth.uid, 'deleteUserAccount', 3);

  const uid = context.auth.uid;

  // Delete all subcollections under users/{uid}
  const subcollections = ['medications', 'schedules', 'reminders', 'adherenceRecords', 'caregiverLinks'];
  for (const col of subcollections) {
    const snapshot = await db.collection('users').doc(uid).collection(col).get();
    const batch = db.batch();
    snapshot.docs.forEach(doc => batch.delete(doc.ref));
    if (snapshot.docs.length > 0) await batch.commit();
  }

  // Delete caregiverAccess docs where this user is a caregiver
  const caregiverPatientsSnapshot = await db.collection('caregiverAccess').doc(uid).collection('patients').get();
  if (caregiverPatientsSnapshot.docs.length > 0) {
    const batch = db.batch();
    caregiverPatientsSnapshot.docs.forEach(doc => batch.delete(doc.ref));
    await batch.commit();
  }
  // Also delete the caregiverAccess/{uid} parent doc if it exists
  await db.collection('caregiverAccess').doc(uid).delete().catch(() => {});

  // Delete caregiverAccess docs where this user is a PATIENT (collectionGroup query)
  const patientLinksSnapshot = await db.collectionGroup('patients')
    .where('patientId', '==', uid)
    .get();
  if (patientLinksSnapshot.docs.length > 0) {
    const batch = db.batch();
    patientLinksSnapshot.docs.forEach(doc => batch.delete(doc.ref));
    await batch.commit();
  }

  // Delete pending invites created by this user
  const pendingInvites = await db.collection('invites')
    .where('patientId', '==', uid)
    .get();
  if (pendingInvites.docs.length > 0) {
    const batch = db.batch();
    pendingInvites.docs.forEach(doc => batch.delete(doc.ref));
    await batch.commit();
  }

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
exports.cleanupExpiredInvites = functions.pubsub.schedule('every 24 hours').onRun(async () => {
  const now = new Date();
  const expired = await db.collection('invites')
    .where('expiresAt', '<', now)
    .where('status', '==', 'pending')
    .get();

  const batch = db.batch();
  expired.docs.forEach(doc => batch.delete(doc.ref));
  await batch.commit();

  console.log(`Cleaned up ${expired.size} expired invites`);
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
