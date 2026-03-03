<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-03-01 | Updated: 2026-03-01 -->

# premium — Premium Upsell Screen

## Purpose
Premium subscription upsell screen shown to free users when they attempt to access premium-gated features.

## Key Files

| File | Description |
|------|-------------|
| `premium_upsell_screen.dart` | PremiumUpsellScreen — feature list, pricing, subscribe CTA |

## For AI Agents

### Working In This Directory
- **Feature flag**: `kPremiumEnabled = false` in `core/constants/feature_flags.dart`
- When `kPremiumEnabled` is false, this screen and related flows are inactive
- IAP integration: uses `subscriptionProvider` and `in_app_purchase` plugin
- iOS: must include "Restore Purchases" button (App Store requirement)
- No direct payments — only Apple IAP / Google Play Billing

### Common Patterns
- `ref.watch(subscriptionProvider)` to check current subscription status
- `ref.read(subscriptionProvider.notifier).purchase(productId)` for purchase flow
- Handle `PurchaseStatus.pending`, `purchased`, `error` states

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
