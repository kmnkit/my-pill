# Consumer Review Panel Report — 2026-02-25

## Gate Decision: FAIL

The app does not meet minimum threshold for launch readiness.

| Metric | Score | Threshold |
|--------|-------|-----------|
| Keep-using average | **5.2/10** | 7.0+ required |
| Recommend average | **4.0/10** | 6.5+ required |
| Use-Recommend gap | 1.2 points | — |
| Paid conversion | 1 YES, 2 conditional, 3 NO | — |

---

## Panel Composition (6 Personas)

### 1. Tanaka Yoshiko (74F) — Elderly Multi-Medication Patient
- **Profile**: Hypertension + diabetes, 5 daily medications, lives alone, limited smartphone skills
- **Device**: iPhone SE (small screen), large font setting enabled

| Category | Score | Notes |
|----------|-------|-------|
| First Impression | 5/10 | "Pretty but text is small" |
| Feature Completeness | 4/10 | Cannot represent her actual prescription (missing timing) |
| UX/UI Flow | 3/10 | Onboarding too long, got lost at timezone step |
| Perceived Value | 4/10 | "My pharmacy printout does this already" |
| Willingness to Pay | NO | "I don't pay for apps" |
| **Overall** | **4/10** | — |

**Key Quotes:**
- "Why does it ask about timezones? I never travel."
- "I need to know if this is before or after meals. The doctor always tells me that."
- "An advertisement appeared after I took my medicine. I thought I pressed something wrong."

**Pain Points:**
- Onboarding step 4 (timezone) is confusing and irrelevant for her
- No 食前/食後/食間 timing — her prescription says "朝食後" and she can't enter that
- Interstitial ad after medication check caused panic (thought she broke something)
- Font too small on medication detail screen
- Cannot figure out how to add a second medication

---

### 2. Sato Mika (38F) — Working Mother Managing Family Medications
- **Profile**: Managing her allergy meds + 2 children's cold medicine, organized, time-pressed
- **Device**: iPhone 15, comfortable with apps

| Category | Score | Notes |
|----------|-------|-------|
| First Impression | 6/10 | Clean design, but where are the profiles? |
| Feature Completeness | 5/10 | No family member separation is a dealbreaker |
| UX/UI Flow | 6/10 | Smooth for single user, breaks down for family use |
| Perceived Value | 5/10 | "Good for me alone, useless for family management" |
| Willingness to Pay | Conditional | "Only if family profiles are added" |
| **Overall** | **5/10** | — |

**Key Quotes:**
- "I need to separate my medications from my daughter's. Right now everything is mixed together."
- "The pill color picker is cute but I wish I could take a photo of the actual pill."
- "The adherence chart is nice for me but meaningless when it mixes adult and child data."
- "I'd pay if it could manage my whole family properly."

**Pain Points:**
- No family member profiles — all medications in one flat list
- Cannot distinguish "who" a medication belongs to
- Adherence data is meaningless when mixed across family members
- Would like photo-based pill identification
- Export report mixes all family medications

---

### 3. Suzuki Kenji (45M) — Remote Caregiver
- **Profile**: Lives in Tokyo, monitors 74-year-old mother in Osaka, tech-comfortable
- **Device**: Android (Pixel 8), uses multiple health apps

| Category | Score | Notes |
|----------|-------|-------|
| First Impression | 7/10 | "Finally something in Japanese for caregiving" |
| Feature Completeness | 5/10 | Caregiver flow is backwards |
| UX/UI Flow | 4/10 | Invite flow requires patient to initiate — his mother can't do that |
| Perceived Value | 6/10 | "The concept is right but execution needs work" |
| Willingness to Pay | Conditional | "Yes if the invite flow is fixed" |
| **Overall** | **5/10** | — |

**Key Quotes:**
- "My mother cannot generate a QR code. I need to be the one initiating the connection."
- "The caregiver dashboard is actually well-designed once you're connected."
- "Real-time alerts when she misses a dose — this is exactly what I need."
- "But if I can't even get past the connection step, none of it matters."

**Pain Points:**
- **Caregiver invite flow is backwards**: Patient must initiate (generate QR/link), but elderly patients often cannot do this. Caregiver should be able to send an invite that the patient simply accepts.
- No "simplified mode" for the patient side (his mother only needs: see medications, tap "taken")
- Caregiver dashboard doesn't show medication timing in mother's local timezone
- No push notification when patient connects (had to keep checking manually)
- Cannot set up mother's medications remotely

---

### 4. Yamada Ayaka (32F) — Pharmacist (Professional Perspective)
- **Profile**: Community pharmacist, evaluates medication apps for patient recommendations
- **Device**: iPhone 14 Pro, tests many health apps

| Category | Score | Notes |
|----------|-------|-------|
| First Impression | 6/10 | "Visually polished, but medically incomplete" |
| Feature Completeness | 3/10 | Missing fundamental Japanese prescription concepts |
| UX/UI Flow | 7/10 | "The UX is actually good for what it does" |
| Perceived Value vs Competition | 4/10 | "Cannot recommend over お薬手帳 apps" |
| Willingness to Pay | NO | "I cannot recommend a paid medical app with interstitial ads" |
| **Overall** | **5/10** | — |

**Key Quotes:**
- "The most critical missing feature for the Japanese market is dosage timing — 食前、食後、食間、就寝前. Without this, you cannot represent a single Japanese prescription accurately."
- "Recommending a medical app with interstitial ads is professionally irresponsible. Patients could tap wrong buttons in confusion."
- "The 一包化 feature is marketed but you can't actually record which medications are inside each pack. That's the whole point."
- "The pill shape/color selector is genuinely useful — I wish お薬手帳 apps had this."
- "If you fix the medical accuracy issues, this could be a serious competitor."

**Critical Professional Issues:**
1. **No dosage timing (用法)**: Japanese prescriptions always specify 食前/食後/食間/就寝前/頓服. This is not optional — it's the standard.
2. **No 用量 per timing**: e.g., "朝食後2錠、夕食後1錠" — different doses at different times
3. **一包化 composition**: Cannot record individual medications within a dose pack
4. **No 処方日数**: Prescription duration in days (important for refill timing)
5. **No 薬局/医療機関 association**: Which pharmacy/hospital prescribed this
6. **Interstitial ads in medical context**: Ethically problematic, could cause medication errors

---

### 5. Emily Chen (29F) — English-Speaking Expat in Japan
- **Profile**: American living in Tokyo, takes allergy medication, limited Japanese
- **Device**: iPhone 15, prefers English interface

| Category | Score | Notes |
|----------|-------|-------|
| First Impression | 7/10 | "Clean, modern, finally an English option" |
| Feature Completeness | 6/10 | "Covers my simple needs well" |
| UX/UI Flow | 6/10 | "EN | JP" toggle is confusing; some strings are still Japanese |
| Perceived Value | 5/10 | "Medisafe does most of this already" |
| Willingness to Pay | NO | "Not when free alternatives exist" |
| **Overall** | **6/10** | — |

**Key Quotes:**
- "The travel/timezone mode is the only feature Medisafe doesn't have. That's genuinely useful."
- "The language selector shows 'EN | JP' — what does that mean? Just say 'English' and '日本語'."
- "Some error messages are still in Japanese even when I set it to English."
- "The onboarding asked me about my 'role' — patient or caregiver. I'm just taking allergy pills, this feels heavy."

**Pain Points:**
- Language selector uses codes ("EN | JP") instead of full language names
- Incomplete English localization (some strings fall through to Japanese)
- Role selection in onboarding is confusing for simple medication users
- No explanation of why "Anonymous" login exists (looks suspicious)
- Travel mode is great but requires timezone knowledge (should auto-detect)

---

### 6. Ito Haruki (21M) — Gen-Z University Student with ADHD
- **Profile**: Takes ADHD medication (Concerta), privacy-conscious, expects gamification
- **Device**: Android (Galaxy S24), heavy app user

| Category | Score | Notes |
|----------|-------|-------|
| First Impression | 5/10 | "Looks like a hospital app, not something I'd want on my phone" |
| Feature Completeness | 5/10 | "Does the basics but nothing exciting" |
| UX/UI Flow | 5/10 | "Too many steps to do anything" |
| Perceived Value | 4/10 | "I'd just use iPhone reminders" |
| Willingness to Pay | NO | "Absolutely not" |
| **Overall** | **5/10** | — |

**Key Quotes:**
- "There's no streak counter? No achievements? I need something to make me actually open the app."
- "The notification just says the medication name. If someone sees my screen, they know I take ADHD meds. Can I customize what the notification shows?"
- "The adherence chart is cool but depressing. Show me what I did RIGHT, not what I missed."
- "I don't want to enter my real name. Why is it required in onboarding?"
- "The design is fine but it's boring. Medisafe at least has some personality."

**Pain Points:**
- **Notification privacy**: Notification content reveals medication name (stigma concern for ADHD, mental health, HIV medications)
- No gamification (streaks, achievements, badges) — zero retention mechanism for younger users
- Onboarding requires name entry (privacy concern)
- Adherence chart emphasizes failures over successes
- No dark mode customization beyond system setting
- No widget customization (wants minimal widget that doesn't show medication names)
- App icon/name "くすりどき" immediately identifies it as a medication app (stigma)

---

## Scoring Matrix

| Panelist | First Impression | Features | UX/UI | Value | Pay? | Overall |
|----------|:---:|:---:|:---:|:---:|:---:|:---:|
| 1. Yoshiko (74F) | 5 | 4 | 3 | 4 | NO | **4** |
| 2. Mika (38F) | 6 | 5 | 6 | 5 | Cond. | **5** |
| 3. Kenji (45M) | 7 | 5 | 4 | 6 | Cond. | **5** |
| 4. Ayaka (32F, pharmacist) | 6 | 3 | 7 | 4 | NO | **5** |
| 5. Emily (29F) | 7 | 6 | 6 | 5 | NO | **6** |
| 6. Haruki (21M) | 5 | 5 | 5 | 4 | NO | **5** |
| **Average** | **6.0** | **4.7** | **5.2** | **4.7** | **1/6** | **5.0** |

---

## Priority Issues

### P0 — Must Fix Before Launch

#### P0-1: Interstitial Ads After Medication Actions
- **Flagged by**: 6/6 panelists
- **Impact**: Trust destruction, potential medication errors
- **Fix**: Remove interstitial ads from medication-related flows entirely. Show ads only in non-medical contexts (settings browsing, report viewing idle states). Or: move to banner-only model for free tier.

#### P0-2: Missing Dosage Timing (食前/食後/食間/就寝前)
- **Flagged by**: Panelists 1, 2, 4 (pharmacist declared it "the most critical missing feature")
- **Impact**: Cannot represent Japanese prescriptions accurately
- **Fix**: Add `DosageTiming` enum with values: 食前 (before meals), 食後 (after meals), 食間 (between meals), 就寝前 (before bed), 起床時 (upon waking), 頓服 (as needed). Associate timing with each schedule entry.

#### P0-3: 一包化 Composition Input
- **Flagged by**: Panelists 1, 4
- **Impact**: Key differentiator (一包化対応) is marketing without substance
- **Fix**: Allow users to associate existing medications with a dose pack group. Show which individual medications are in each pack on the timeline.

### P1 — Should Fix Before Launch

#### P1-1: Caregiver Invite Flow Direction
- **Flagged by**: Panelist 3
- **Fix**: Allow caregiver to initiate invite (send link/code TO patient). Patient only needs to tap "accept."

#### P1-2: Family Member Profiles
- **Flagged by**: Panelist 2
- **Fix**: Add profile/person selector. Each medication belongs to a person. Adherence tracked per person.

#### P1-3: Onboarding Length
- **Flagged by**: Panelists 1, 5, 6
- **Fix**: Reduce to 3 steps: Welcome+Auth → Name+Role → Done. Move timezone and notification to Settings (with smart defaults).

#### P1-4: Notification Privacy
- **Flagged by**: Panelist 6
- **Fix**: Option to show generic notification text ("Time for your routine" instead of "Time to take Concerta").

### P2 — Should Fix Post-Launch

#### P2-1: Language Selector UX
- Show full language names ("English", "日本語") instead of codes ("EN | JP")

#### P2-2: Gamification / Retention
- Streak counter, weekly achievement badges, positive reinforcement in adherence view

#### P2-3: Positive Adherence Framing
- Show "X days streak" and "Y% this week" prominently; de-emphasize missed doses

#### P2-4: Anonymous Login Explanation
- Add tooltip or description explaining anonymous login (data stays on device only)

#### P2-5: Pharmacist/Hospital Association
- Allow associating medications with prescribing doctor/pharmacy

---

## Strengths to Preserve

1. **Timeline card inline check** — "3 seconds and done" (4/6 praised)
2. **Travel/timezone mode** — unique differentiator vs Medisafe
3. **Japanese-native caregiver linking** — "nothing else exists in Japanese"
4. **Pill shape/color visual identification** — pharmacist praised this specifically
5. **Glass morphism design language** — visually distinctive
6. **PDF report for doctors** — practical value for medical visits

---

## Competitive Position

| Feature | Kusuridoki | Medisafe | お薬手帳 Apps |
|---------|:---:|:---:|:---:|
| Japanese prescription timing | - | - | YES |
| Pill visual identification | YES | Partial | - |
| Caregiver monitoring (Japanese) | YES | English only | - |
| Travel/timezone mode | YES | - | - |
| 一包化 support | Partial | - | - |
| Gamification | - | YES | - |
| Ad-free experience | Paid | Paid | Free |
| Family profiles | - | YES | - |

---

## Recommended Action Plan

1. **Immediate (P0)**: Fix interstitial ad placement, add dosage timing, complete 一包化 composition
2. **Pre-launch (P1)**: Fix caregiver invite direction, shorten onboarding, add notification privacy option
3. **Post-launch (P2)**: Family profiles, gamification, language selector UX, positive framing
4. **Re-gate**: Run consumer panel again after P0+P1 fixes with same personas

---

*Generated by Consumer Review Panel Agent — 2026-02-25*
*Panel size: 6 personas | Gate threshold: 7.0/10 keep-using, 6.5/10 recommend*
