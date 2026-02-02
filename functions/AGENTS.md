<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# functions — Firebase Cloud Functions

## Purpose
Server-side Node.js Cloud Functions handling caregiver invitation linking, access management, and scheduled cleanup. These functions run on Firebase and manage operations requiring atomic writes and trusted execution.

## Key Files

| File | Description |
|------|-------------|
| `index.js` | All Cloud Functions — invite generation, acceptance, revocation, cleanup |
| `package.json` | Node 18 runtime, Firebase Admin SDK v12, Cloud Functions v5 |

## For AI Agents

### Working In This Directory
- **Runtime**: Node.js 18 with Firebase Admin SDK
- Functions are deployed via `firebase deploy --only functions`
- All functions use Firebase Admin SDK for Firestore access (bypasses security rules)
- Invite codes are 8 alphanumeric chars (excludes I, O, L, 0 for readability)

### Key Functions

| Function | Type | Purpose |
|----------|------|---------|
| `generateInviteLink` | HTTPS Callable | Creates 7-day expiring invitation code |
| `acceptInvite` | HTTPS Callable | Validates invite and creates bidirectional caregiver links |
| `revokeAccess` | HTTPS Callable | Patient-initiated removal of caregiver access |
| `cleanupExpiredInvites` | Pub/Sub Scheduled | Daily cleanup of expired pending invites |

### Testing Requirements
- Test locally with `firebase emulators:start`
- Verify atomic batch writes succeed/fail correctly
- Test invite expiry edge cases

### Common Patterns
- Atomic batch writes for bidirectional link creation
- Authenticated callable functions (`context.auth` check)
- Error codes: `unauthenticated`, `not-found`, `failed-precondition`

## Dependencies

### External
- `firebase-admin` v12 — Firestore, Auth admin operations
- `firebase-functions` v5 — Cloud Functions SDK

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
