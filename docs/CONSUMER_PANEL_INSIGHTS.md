# Consumer Panel Insights

Date: 2026-02-22

## Panel Composition (7 members)

| # | Name | Age | Profile |
|---|------|-----|---------|
| 1 | 田中 | 72 | Elderly patient, daily medications, low tech literacy |
| 2 | Emily | 34 | Working mother, manages child's medication |
| 3 | 佐藤 | 58 | Caregiver for elderly parent |
| 4 | Alex | 28 | Young professional, occasional supplements |
| 5 | 山本 | 65 | Chronic condition, multiple daily medications |
| 6 | 中村 | 22 | College student, ADHD medication |
| 7 | Maria | 38 | Night-shift nurse, irregular schedule |

## Score Summary

| Metric | Score |
|--------|-------|
| Continued Use Intent | 6.3/10 |
| Recommendation Intent | 4.9/10 |
| Paid Conversion Intent | 3.8/10 |
| Use-Recommend Gap | 1.4 points |

### Gap Analysis

The 1.4-point gap between use intent (6.3) and recommendation intent (4.9) is primarily driven by:
1. **Missing Privacy Policy** — cannot recommend an app without visible privacy handling
2. **Interstitial ads on health data screens** — perceived as inappropriate for a medical app

## Hidden Insights

### 1. Shift Worker Segment (Maria #7)

Maria works rotating night shifts. Current daily schedule assumes a fixed wake/sleep cycle. She requested:
- Flexible scheduling based on shift patterns (day/night/off)
- "Shift mode" similar to travel mode but for work schedules
- **Opportunity**: Underserved segment — most medication apps assume 9-to-5 routines

### 2. Doctor Visit PDF Scenario (Yamamoto #5)

Yamamoto mentioned: "I want to print my adherence history and show it to my doctor at my next visit."
- Current PDF export exists but is premium-gated
- **Insight**: For elderly patients managing chronic conditions, this is a core need, not a premium perk
- Consider: Free monthly PDF, premium for weekly/custom date ranges

### 3. Gamification for Retention (Nakamura #6)

Nakamura (college student, ADHD) explicitly asked for:
- Streak counter ("I've taken meds 14 days in a row!")
- Weekly achievement badges
- **Insight**: Younger users need extrinsic motivation; current app is purely functional
- Low implementation cost, high retention impact for 18-30 demographic

### 4. Caregiver Direct Routing (Sato #3)

After completing onboarding and selecting "Caregiver" role, Sato was routed to the patient home screen.
- Expected to land directly on caregiver dashboard
- **Fix**: Route `onboardingRoleCaregiver` → `/caregiver/patients` instead of `/home`

### 5. Per-Medication Travel Mode (3 panelists)

Three panelists (田中, 山本, Maria) independently noted:
- Some medications must stay on home timezone (e.g., insulin)
- Others can shift to local time (e.g., vitamins)
- Current travel mode applies one strategy to all medications
- **Enhancement**: Per-medication timezone strategy in travel mode settings

### 6. Banner Ad Misclick for Elderly (Tanaka #1)

田中 (age 72) repeatedly tapped banner ads accidentally:
- Larger touch targets + proximity to navigation elements = frequent misclicks
- Each misclick opens browser → confusing navigation back to app
- **Risk**: App store rejection for deceptive ad placement (elderly user segment)
- **Recommendation**: Increase ad padding, consider ad-free default for accessibility mode

## P1/P2 Backlog

### P1 (Next Sprint)

- [ ] Caregiver role → direct routing to caregiver dashboard
- [ ] Streak counter on home screen
- [ ] Banner ad padding increase for accessibility

### P2 (Future)

- [ ] Shift worker scheduling mode
- [ ] Per-medication travel mode strategy
- [ ] Free monthly PDF export (premium gate for weekly/custom)
- [ ] Achievement badges / gamification system
- [ ] Doctor visit preparation workflow (pre-formatted report)
