<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# widgets — Caregiver Screen Widgets

## Purpose
Feature-specific widgets for the caregiver system including caregiver list management, privacy notices, patient monitoring cards, and QR code invite sharing.

## Key Files

| File | Description |
|------|-------------|
| `caregiver_list_tile.dart` | `CaregiverListTile` — linked caregiver display with revoke access action |
| `privacy_notice.dart` | `PrivacyNotice` — data sharing disclosure shown before invite generation |
| `patient_card.dart` | `PatientCard` — caregiver dashboard card showing patient status (taken/missed/low stock) |
| `qr_invite_section.dart` | `QrInviteSection` — QR code display with share link button for invitations |

## For AI Agents

### Working In This Directory
- Privacy notice must be acknowledged before generating invites
- QR code encodes the invite URL (`https://mypill.app/invite/{code}`)
- Patient card shows real-time status via Firestore stream
- Caregiver list tile includes swipe-to-revoke or revoke button

## Dependencies

### Internal
- `data/providers/caregiver_provider.dart` — Link management
- `data/models/caregiver_link.dart` — Link data
- `presentation/shared/widgets/` — MpCard, MpButton
- `core/constants/` — Design tokens

### External
- `qr_flutter` — QR code generation
- `share_plus` — Share functionality

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
