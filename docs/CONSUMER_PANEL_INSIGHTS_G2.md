# Consumer Panel Insights — G2

Date: 2026-02-26
Previous: [G1 — 2026-02-22](./CONSUMER_PANEL_INSIGHTS.md)

## Panel Composition (7 members)

| # | Age/Gender | Profile | Tech Literacy | Domain Exp | Motivation | Churn Sensitivity |
|---|-----------|---------|---------------|-----------|------------|-------------------|
| 1 | 68F | Retired Japanese homemaker, multiple chronic conditions | Low | Beginner | High | High |
| 2 | 27M | US startup PM, supplement user | High | Experienced | Medium | High |
| 3 | 48F | Japanese nurse, shift worker | Medium | Heavy user | High | Medium |
| 4 | 34M | UK freelance developer, frequent traveler | High | Experienced | Medium | High |
| 5 | 62M | Japanese self-employed, newly diagnosed diabetes | Low | Beginner | High | Low |
| 6 | 16F | Japanese high school student, ADHD medication | Medium | Beginner | Medium | High |
| 7 | 43F | Japanese living in Canada, remote parent monitoring | Medium | Experienced | High | Medium |

## Score Summary

| Metric | G2 Score | G1 Score | Delta |
|--------|----------|----------|-------|
| Continued Use Intent | **6.4/10** | 6.3/10 | +0.1 |
| Recommendation Intent | **5.3/10** | 4.9/10 | +0.4 |
| Use-Recommend Gap | **1.1 pts** | 1.4 pts | -0.3 (improved) |

### Individual Scores — Continued Use

| # | Score | Key Reason |
|---|-------|-----------|
| 1 | 5 | Hard to add medications alone; needs daughter's help |
| 2 | 7 | Travel Mode is the killer feature |
| 3 | 7 | 食前/食後 + Travel Mode value recognized |
| 4 | 7 | Travel Mode decisive; would be 8 if offline status clarified |
| 5 | 7 | Inline medication check is convenient |
| 6 | 4 | No gamification — expects deletion within a month |
| 7 | 8 | Remote monitoring fits her needs perfectly |

### Individual Scores — Recommendation

| # | Score | Key Reason |
|---|-------|-----------|
| 1 | 4 | Too complex for peers |
| 2 | 5 | Only for tech-savvy Travel Mode seekers |
| 3 | 6 | Can recommend to regular day-shift patients |
| 4 | 6 | Only for Travel Mode users |
| 5 | 6 | Would tell diabetic friends |
| 6 | 3 | Friends would say "boring" |
| 7 | 7 | Strong recommend in overseas Japanese community |

### Paid Conversion Intent

| # | Intent | Price Ceiling | Condition |
|---|--------|--------------|-----------|
| 1 | Low | — | Passive; daughter would handle |
| 2 | Medium | <$3/mo | If gamification added |
| 3 | Medium | ¥2,000/yr | If shift-work mode added |
| 4 | Medium | <¥3,000/yr | If offline behavior clarified |
| 5 | Low | Free is enough | Would consider if doctor report added |
| 6 | None | — | Won't use even for free without gamification |
| 7 | High | <¥400/mo | Would subscribe now |

## Common Issues (3+ panelists)

### 1. Onboarding → Login Role Duplication (4/7)

- **Panelists:** #1, #2, #3, #4
- **Severity:** HIGH — causes churn
- **Code:** `onboarding_screen.dart` L74-76: `_completeOnboarding()` routes to `/login`; role value not passed. `login_screen.dart` L200-232 asks for role again.
- **Quote:** "I already chose my role in onboarding, then had to choose again at login — made me doubt my settings were saved."
- **Status:** Reported in G1, still unfixed

### 2. Zero Gamification — No Feedback After Check-in (4/7)

- **Panelists:** #2, #3, #6, #7
- **Severity:** MEDIUM — causes mid/long-term churn
- **Code:** `timeline_card.dart` L117-137 — only icon color change on completion; no streak, badge, or celebration
- **Quote:** "If Duolingo-style 14-day streak flames appeared, I'd keep using it. Just a green check isn't enough motivation."

### 3. Empty Medication List Has No CTA Button (3/7)

- **Panelists:** #1, #5, #6
- **Severity:** HIGH — core feature entry barrier
- **Code:** `medications_list_screen.dart` L100-106 — `MpEmptyState` has no `actionLabel`/`onAction`. AppBar `IconButton` (L65-69) has no text label.
- **Quote:** "There's a tiny + button in the top right but I had no idea what it was for."

### 4. No Offline Status Transparency (3/7)

- **Panelists:** #2, #4, #7
- **Severity:** MEDIUM — erodes trust for travelers/overseas users
- **Quote:** "If I check my medication on a plane, I have no idea if it'll sync later."

### 5. Caregiver Connection Path Too Deep (3/7)

- **Panelists:** #1, #5, #7
- **Severity:** MEDIUM — hampers key differentiating feature adoption
- **Code:** `settings_screen.dart` L66-78 — family/caregiver menu buried in Settings "Features" section

## Common Praise (3+ panelists)

### 1. Inline Medication Check (4/7: #1, #3, #5, #7)

- **Code:** `timeline_card.dart` L117-129 — `markAsTaken` callable directly from home screen without entering detail view

### 2. Travel Mode (4/7: #2, #3, #4, #7)

- **Code:** `travel_mode_screen.dart` — Fixed Interval / Local Time strategy selection

### 3. EN/JA Bilingual Support (3/7: #3, #4, #7)

### 4. 食前/食後/食間 Dosage Timing (3/7: #3, #5, #7)

## Notable Individual Opinions

| # | Opinion | Why It Matters |
|---|---------|---------------|
| #3 Nurse | "No medication app supports shift-work schedules (day/night rotation)." | High % of healthcare workers on shifts. Adjacent need solvable via Travel Mode extension |
| #4 Developer | "Routing to `/login` after onboarding is a structural bug — role value isn't passed." | Precise code-level identification. Fix: `onboarding_screen.dart` L74 |
| #5 Diabetic | "Stock warning banner just shows 'N pills left' — needs action guidance like 'Time to refill your prescription'." | Chronic-condition elderly users need behavioral guidance. Copy fix only |
| #6 Student | "Encouraging messages like 'Keep it up today!' in notifications would be so much better." | Gen-Z notification tone — emotional messages improve both open rate and adherence |
| #7 Caregiver | "Free limit of 1 caregiver connection is too few — families with 2 children can't manage." | Family connection is the key differentiator but current limit creates barrier. Consider 2 free |
| #1 Elderly | "I would have trusted the app more if I could see the privacy policy right from the start screen." | Elderly medical users' trust depends on early transparency |

## One-Line Quotes

| # | Quote |
|---|-------|
| 1 | "The medication check button was nice, but there were too many setup steps — I would have given up without my daughter." |
| 2 | "Timezone feature is genuinely great. But onboarding duplication and lack of gamification hold it back. Not quite a Medisafe killer yet." |
| 3 | "食前/食後 support shows the developer understands clinical needs, but the lack of shift-work scheduling means healthcare workers can't fully use it." |
| 4 | "Travel Mode is the real deal, but onboarding routing duplication and offline opacity are holding it back." |
| 5 | "The medication check button is everything — it's so convenient that I tolerate the rest." |
| 6 | "I get it's a medication reminder app, but with zero reaction when I take my meds, I don't see why I'd keep using it." |
| 7 | "The remote caregiver feature alone makes this worth it — but simplify the family connection path and make 2 caregivers free." |

## Improvement Priority Matrix

### P0 — Fix Immediately

| # | Issue | File | Effort |
|---|-------|------|--------|
| 1 | Onboarding → Login role duplication | `onboarding_screen.dart` L74-76 | ~1h |
| 2 | Empty medication list CTA button | `medications_list_screen.dart` L100-106 | ~30min |

### P1 — Next Sprint

| # | Issue | Impact |
|---|-------|--------|
| 1 | Home screen streak counter + haptic/toast on check-in | Mid/long-term retention |
| 2 | Offline status banner ("Offline — your records are saved") | Traveler/overseas user trust |
| 3 | Caregiver connection prompt on onboarding or first home visit | Key feature discoverability |
| 4 | Stock warning banner copy improvement ("N days left. Check your prescription.") | Elderly user actionability |
| 5 | English UI: "Ippoka" → "Dose Pack Mode" label | EN user comprehension |
| 6 | Rename "Adherence" tab → "History" or "My Record" | Friendlier label |

### P2 — Backlog

| # | Issue | Impact |
|---|-------|--------|
| 1 | Shift-work scheduling mode (Travel Mode extension) | Healthcare worker segment |
| 2 | Expand free caregiver limit to 2 | Family adoption |
| 3 | Data storage location transparency (Settings > About) | Trust/compliance |
| 4 | Extended medication details (doctor, prescription expiry, pharmacy) | Clinical utility |
| 5 | Emotional notification messages ("Day N streak! Great job!") | Gen-Z retention |

## G1 → G2 Delta Analysis

| G1 Issue | G2 Status |
|----------|-----------|
| Missing Privacy Policy | Resolved — no longer flagged |
| Interstitial ads on health screens | Resolved — no longer flagged |
| Caregiver routing after onboarding | Partially addressed — G2 still flags deep navigation path |
| Streak counter request | Still unfixed — now flagged by 4/7 (was 1/7 in G1) |
| Banner ad misclick for elderly | No longer flagged — likely addressed |
| Per-medication travel mode | Not flagged in G2 — lower priority confirmed |

### New in G2 (not in G1)

- Offline status transparency (3/7)
- Empty medication list CTA (3/7)
- Onboarding → Login role duplication explicitly linked to code (4/7)
- Caregiver connection depth issue (3/7)

## Conclusion

Kusuridoki has clear differentiation with inline medication check, Travel Mode, EN/JA bilingual support, and 食前/食後 timing — a combination no competitor offers. The use-recommend gap narrowed from 1.4 to 1.1 points (G1→G2), indicating improvement. However, two P0 issues from G1 remain unfixed (onboarding role duplication, empty state CTA), and gamification absence is now a louder signal (4/7 vs 1/7 in G1). Fixing P0 items and adding a streak counter before G3 is strongly recommended.
