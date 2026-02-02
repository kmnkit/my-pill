# Product Requirements Document (PRD): Medication Management App "MyPill" (Tentative Model)

## 1. Product Overview
A global medication management application designed for the Japanese and English-speaking markets. The app ensures users take their medication on time and allows family members or caregivers to monitor adherence remotely.

**Core Value Proposition:**
- **Reliability:** Simplifies managing complex medication schedules.
- **Connectivity:** Bridges the gap between patients and caregivers via seamless linking.
- **Global Mobility:** Smartly handles timezone changes for travelers (e.g., maintain home interval vs. shift to local time).

## 2. Target Audience
1.  **Primary Users:** Individuals with chronic conditions or daily supplements (Elderly, Busy professionals, Travelers).
2.  **Secondary Users (Caregivers):** Family members living apart, Parents managing children's medication.

## 3. Core Features

### 3.1. Medication Management
-   **Add Medication:**
    -   Name, Dosage, Shape (Icon), Color.
    -   Optional: Photo of the pill.
    -   Schedule: Daily (X times), Specific Days, Interval based.
    -   *Inventory Tracking:* Input total quantity; deduct upon "Taken" action. Alert when stock is low (e.g., < 3 days).
-   **Reminders:**
    -   Push notifications.
    -   "Snooze" and "Skip" options.
    -   Critical Alert support (override mute) for essential meds (optional setting).

### 3.2. Global Timezone Support (Killer Feature)
-   **Travel Mode:**
    -   Detect timezone change.
    -   User Choice:
        1.  **Fixed Interval (Home Time):** "Take every 24h regardless of sun" (e.g., Insulin).
        2.  **Local Time Adaptation:** "Shift morning meds to local morning".
-   **Language:**
    -   Switch between Japanese and English instantly within app settings.

### 3.3. Caregiver/Family Linking
-   **Link Mechanism:**
    -   **Generate Invite:** User creates a unique invitation link (Dynamic Link) or QR Code.
    -   **Share:** Send via LINE, Email, Message.
    -   **Connect:** Caregiver installs app (or opens web view if supported later) -> Scans/Clicks -> "Connected".
-   **Caregiver Dashboard:**
    -   View list of linked patients.
    -   Real-time status: "Taken", "Missed", "Low Stock".
    -   *Privacy:* Patient can revoke access at any time.



### 3.4. AI Drug Safety (Experimental / Future)
-   *Priority:* Low (Experimental).
-   *Function:* Check interactions (Drug-Drug, Drug-Food).
-   *Implementation:*
    -   Initial Phase: Static list of common bad pairings (e.g., Grapefruit + Statins).
    -   Future: Secure API call to vetted medical DB or AI agent with strict caveats.

## 4. Technical Specifications

### 4.1. Architecture
-   **Frontend:** Flutter (iOS/Android).
-   **Backend:** Firebase (BaaS).
    -   **Auth:** Anonymous (start), Email/Password, Social Login (Google/Apple).
    -   **Firestore:** Real-time database for sync.
    -   **Cloud Functions:** For handling complex invites or periodic specific notifications if needed.
    -   **Dynamic Links (or equivalent):** For deep linking invites.

### 4.2. Data Privacy
-   Strict security rules in Firestore.
-   Caregivers only read specific sub-collections of linked users.

## 5. Monetization
-   **Model:** Free + Ads.
-   **Ad Placement:**
    -   Banner at bottom of main specific screens (not obstructing controls).
    -   Interstitial (rarely, perhaps only after setup or distinct non-critical flows) - *Careful with UX.*
-   **Potential IAP:** "Remove Ads" (One-time purchase or low subscription).

## 6. Design Guidelines (UI/UX)
-   **Tone:** Trustworthy, Clean, Medical but Approchable.
-   **Style:**
    -   High contrast support for elderly.
    -   Avoid "Childish" characters; use professional iconography.
    -   **Color Palette:** Calming Blues, Teals, with Clear Alerts (Red/Orange).
-   **Widgets:** Home screen widgets for quick "Taken" checks.

## 7. Open Questions / Risks
-   **Deep Linking Reliability:** iOS/Android changes to deep links require careful setup.
-   **Notification Delivery:** Ensuring reliability on battery-optimized Android devices.
