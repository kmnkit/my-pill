# Kusuridoki UI/UX Review

**Date:** 2026-02-25
**Reviewer:** Claude (UI/UX Pro Max skill)
**App Version:** 1.0.0+1

---

## Overall Impression

The app has a **solid foundation** with a clean, healthcare-appropriate design language. The glassmorphism + gradient approach is cohesive, and the teal color palette conveys trust and wellness. However, there are several areas ranging from **critical accessibility issues** to **UX polish improvements** that would elevate the experience.

---

## CRITICAL Issues

### 1. MpCard tappable area lacks feedback (Accessibility + Touch)

**File:** `lib/presentation/shared/widgets/mp_card.dart:74-76`

`GestureDetector` provides **no visual feedback** on tap. Users get zero confirmation that they've pressed an interactive card. This is especially problematic for:
- Elderly users (primary target for medication apps)
- Accessibility users

**Fix:** Replace `GestureDetector` with `InkWell` wrapped in `Material`, or add a pressed state (scale or opacity change).

### 2. MedicationsListScreen card also uses raw GestureDetector

**File:** `lib/presentation/screens/medications/medications_list_screen.dart:118-119`

Same issue as above -- the medication list items have no tap feedback.

### 3. Timeline card check button is below 44x44 minimum

**File:** `lib/presentation/screens/home/widgets/timeline_card.dart:105`

```dart
constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
```

This is **40x40**, below the 44x44px minimum tap target required by WCAG and Apple HIG. For a medication app where the "mark as taken" action is the **most critical user action**, this must be at least 44x44.

### 4. Hardcoded `AppColors.textMuted` ignores dark mode

**Files:** Multiple locations including:
- `greeting_header.dart:61` -- `color: AppColors.textMuted` (light mode color)
- `timeline_card.dart:75` -- `color: AppColors.textMuted`
- `medications_list_screen.dart:144` -- `color: AppColors.textMuted`
- `settings_screen.dart:309` -- `color: AppColors.textPrimary`

These use the **light mode** color constants directly instead of reading from `Theme.of(context)`. In dark mode, `AppColors.textMuted` (#618986) against dark backgrounds will have **poor contrast**.

**Fix:** Use `Theme.of(context).textTheme.bodySmall` colors or create a helper that resolves light/dark automatically.

### 5. HomeScreen doesn't use GradientScaffold

**File:** `lib/presentation/screens/home/home_screen.dart:46`

The home screen uses a plain `Scaffold`, but `MpCard` uses glassmorphism with `BackdropFilter`. **Glass effects need a gradient background to look correct** -- without it, the blur has nothing to blend with and the cards appear as flat semi-transparent boxes.

The gradient may be applied at the shell/router level, but `MedicationsListScreen` and `WeeklySummaryScreen` also use plain `Scaffold` -- verify that all glass-card-containing screens get the gradient background.

---

## HIGH Priority Issues

### 6. Inconsistent card implementations

- `HomeScreen` -> uses `MpCard` (glass) via `TimelineCard`
- `MedicationsListScreen` -> uses inline `Container` with `BoxDecoration` (solid)
- `WeeklySummaryScreen` -> delegates to sub-widgets (unknown)

This breaks visual consistency. The medications list should use `MpCard` for uniformity.

### 7. Banner ad positioning can overlap content

**File:** `lib/presentation/screens/home/home_screen.dart:63-73`

The banner ad is placed at the bottom of a `SingleChildScrollView`. Combined with `navBarClearance` padding, this should be fine. But in `MedicationsListScreen:200-212`, the banner is **outside** the scrollable area and could overlap the last list item on smaller screens.

### 8. No skeleton/shimmer loading states

All loading states use `CircularProgressIndicator.adaptive()`. For a modern healthcare app, **skeleton screens** would:
- Reduce perceived loading time
- Prevent content jumping
- Look more polished

### 9. Search field appears even with 0 medications

**File:** `medications_list_screen.dart:73-85`

The search field is always visible. When a user has no medications yet, showing a search bar above an empty state creates confusion. Hide it when `medications.isEmpty`.

### 10. Onboarding uses `colorScheme.surface` instead of gradient

**File:** `onboarding_screen.dart:81`

```dart
backgroundColor: Theme.of(context).colorScheme.surface,
```

The onboarding is the **first impression** of the app. It should use the branded gradient background (`GradientScaffold`) for visual consistency with the rest of the app.

---

## MEDIUM Priority Issues

### 11. Typography: Lexend font may not render Japanese well

**File:** `lib/core/constants/app_typography.dart:42-54`

`GoogleFonts.lexend` is used for **all** text styles. Lexend is a Latin-only font. For Japanese text, the system will fall back to the default sans-serif, creating a **mismatched look** between English and Japanese characters.

**Recommendation:** Use `Noto Sans JP` as the primary font (supports both Latin + Japanese cleanly), or set Lexend for headings and Noto Sans JP for body text.

### 12. No pull-to-refresh on HomeScreen

Healthcare reminder apps benefit from pull-to-refresh to re-sync medication status. The `SingleChildScrollView` doesn't support it -- consider `RefreshIndicator` + `ListView`.

### 13. Bottom nav bar labels are small (12px)

**File:** `mp_bottom_nav_bar.dart:135-136`

```dart
selectedFontSize: 12.0,
unselectedFontSize: 12.0,
```

For elderly users managing medications, 12px labels are quite small. Consider 13-14px, especially since the app already has a text scaling feature.

### 14. Error views are too generic

**File:** `mp_error_view.dart`

The error view shows a single generic icon + message. For a medication app, errors should be more reassuring:
- Show what the user can do
- Offer offline data if available
- Don't alarm users who depend on the app for health management

### 15. Settings screen is very long

**File:** `settings_screen.dart`

The settings screen is a single long scroll. Consider grouping into separate sub-pages for:
- Account & Profile
- Notifications
- Display
- Features
- Privacy & Security
- Advanced/Danger Zone

### 16. No haptic feedback on critical actions

The "mark as taken" button (the most-used action in the app) has no haptic feedback (`HapticFeedback.mediumImpact()`). Adding tactile confirmation improves the sense of accomplishment.

### 17. Missing Semantics labels in several places

While `MpButton` and `MpBadge` have good `Semantics` wrapping, `MpCard` and `TimelineCard` lack semantic descriptions. Screen readers won't know what a tappable card represents.

---

## LOW Priority / Polish

### 18. Glass border colors are nearly invisible in light mode

**File:** `app_colors.dart:68`

```dart
static const Color glassBorder = Color(0x33FFFFFF); // 20% white
```

On a light gradient background (teal -> white), a 20% white border is essentially invisible. Consider using a subtle gray border (`Color(0x1A000000)`) for light mode.

### 19. Empty state icon could be more welcoming

The empty states use Material icons. Consider custom illustrations for key empty states (no medications, no reminders) to make the app feel warmer and more inviting.

### 20. Weekly chart colors are all gray

From the adherence chart screenshot, the bars are all the same gray color regardless of status. Using the existing status colors (green for taken, red for missed) would make the chart more informative at a glance.

### 21. Low stock banner could be more prominent

The low stock warning ("Amlodipine - 残り4錠") is a small banner at the bottom. For medication safety, low stock warnings should be more visually prominent (consider a card with warning color background at the top).

### 22. No transition animations between screens

The onboarding uses page transitions, but the main app navigation appears to use default transitions. Custom page transitions (shared element, fade through) would add polish.

---

## What's Working Well

| Aspect | Assessment |
|--------|-----------|
| **Color palette** | Teal is perfect for healthcare -- calming, trustworthy |
| **Design system** | `AppColors`, `AppSpacing`, `AppTypography` are well-organized |
| **Glassmorphism** | Tasteful, not overdone. High contrast mode fallback is excellent |
| **Accessibility groundwork** | High contrast mode, text scaling, reduced motion checks |
| **Component library** | `Mp`-prefixed widgets create a cohesive language |
| **Dark mode support** | Full light/dark with appropriate color shifts |
| **Spacing system** | Consistent use of `AppSpacing` constants |
| **Status badges** | Clear color coding with appropriate contrast |
| **l10n** | Full EN/JA localization with locale-aware date formatting |
| **Error categorization** | `MpErrorView` translates error codes to user-friendly messages |

---

## Priority Action Items (Top 5)

1. **Fix tap targets to 44x44px minimum** and add tap feedback to all interactive cards
2. **Replace hardcoded color constants** with theme-aware alternatives for dark mode
3. **Add Noto Sans JP** font for proper Japanese rendering
4. **Add skeleton loading** to replace spinner-only loading states
5. **Add haptic feedback** to "mark as taken" action
