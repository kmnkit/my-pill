<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# caregivers — Caregiver & Family Linking

## Purpose
Bidirectional caregiver-patient linking system. Patients can invite caregivers via QR code or deep link. Caregivers get a monitoring dashboard with real-time patient medication status.

## Key Files

| File | Description |
|------|-------------|
| `family_screen.dart` | Patient-side family management — invite generation, caregiver list, access revocation |
| `caregiver_dashboard_screen.dart` | Caregiver-side dashboard — patient cards with real-time status (taken/missed/low stock) |
| `qr_scanner_screen.dart` | QR code scanning for accepting caregiver invitations |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `widgets/` | Caregiver-specific widgets — caregiver list tile, privacy notice, patient card, QR invite section (see `widgets/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Invitation flow: generate code → share via QR/link → caregiver scans/clicks → accept → bidirectional link created
- Cloud Functions handle the server-side linking logic (see `functions/`)
- Real-time monitoring via Firestore streams (`caregiverMonitoringProvider`)
- Patient controls access — can revoke caregiver at any time
- Privacy notice must be shown before sharing patient data

### Common Patterns
- QR code generation with `qr_flutter`
- QR scanning with `mobile_scanner`
- Deep link handling via `deep_link_provider`
- Firestore `StreamProvider` for real-time caregiver data

## Dependencies

### Internal
- `data/providers/caregiver_provider.dart` — Link management
- `data/providers/caregiver_monitoring_provider.dart` — Real-time patient data
- `data/providers/deep_link_provider.dart` — Invite code handling
- `caregivers/widgets/` — Feature-specific widgets

### External
- `qr_flutter` — QR code generation
- `mobile_scanner` — QR code scanning
- `share_plus` — Share invite link

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
