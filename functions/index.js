const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();

// Generate invite link
exports.generateInviteLink = functions.https.onCall(async (data, context) => {
  if (!context.auth) throw new functions.https.HttpsError('unauthenticated', 'Must be signed in');

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

  const { code } = data;
  const caregiverId = context.auth.uid;

  const inviteRef = db.collection('invites').doc(code);
  const invite = await inviteRef.get();

  if (!invite.exists) throw new functions.https.HttpsError('not-found', 'Invalid invite code');

  const inviteData = invite.data();
  if (inviteData.status !== 'pending') throw new functions.https.HttpsError('failed-precondition', 'Invite already used');
  if (inviteData.expiresAt.toDate() < new Date()) throw new functions.https.HttpsError('failed-precondition', 'Invite expired');

  const patientId = inviteData.patientId;
  const batch = db.batch();

  // Create caregiver access
  batch.set(db.collection('caregiverAccess').doc(caregiverId).collection('patients').doc(patientId), {
    patientId,
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

  const { caregiverId, linkId } = data;
  const patientId = context.auth.uid;

  const batch = db.batch();
  batch.delete(db.collection('caregiverAccess').doc(caregiverId).collection('patients').doc(patientId));
  batch.delete(db.collection('users').doc(patientId).collection('caregiverLinks').doc(linkId));
  await batch.commit();

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
  let code = '';
  for (let i = 0; i < 8; i++) {
    code += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return code;
}
