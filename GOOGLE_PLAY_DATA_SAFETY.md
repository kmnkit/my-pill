# Google Play Data Safety Form

Google Play Console > App content > Data safety 에서 작성.

## Data Collection & Sharing

| Data type | Category | Collected | Shared | Required/Optional | Purpose |
|-----------|----------|-----------|--------|-------------------|---------|
| Email address | Personal info | Yes | No | Optional (social login) | Account management |
| Name | Personal info | Yes | No | Optional (social login) | Account management |
| Medications (name, dosage, schedule, adherence) | Health info | Yes | Yes (caregivers) | Required | App functionality |
| Photos (pill images) | Photos | Yes | No | Optional | App functionality |
| Purchase history | Financial info | Yes | Yes (RevenueCat) | Optional (premium) | App functionality |
| Advertising ID | Device or other IDs | Yes | Yes (Google AdMob) | Automatic | Advertising |
| App interactions | App activity | Yes | No | Automatic | Analytics |
| Crash logs | App info and performance | Yes | Yes (Firebase Crashlytics) | Automatic | App functionality |
| Device info (model, OS) | Device or other IDs | Yes | Yes (Firebase Crashlytics) | Automatic | App functionality |
| Timezone / locale | App info and performance | Yes | No | Automatic | App functionality |

## Security Practices

| Question | Answer |
|----------|--------|
| Is data encrypted in transit? | Yes (HTTPS/TLS) |
| Is data encrypted at rest? | Yes (AES-256 local, Firebase server-side) |
| Can users request data deletion? | Yes (Settings > Delete Account) |
| Do you follow Google's Families Policy? | No (app is 13+, not child-directed) |

## Data Sharing Recipients

| Recipient | Data shared | Purpose |
|-----------|------------|---------|
| Google AdMob | Advertising ID, device info | Personalized ads (free tier only) |
| Firebase Analytics | Anonymized usage events | App improvement |
| Firebase Crashlytics | Crash logs, device info, anonymous user ID | Error monitoring |
| RevenueCat | Purchase/subscription data | Subscription management |
| Caregivers (user-authorized) | Medication status, adherence records | App functionality |

## Notes

- Health data (medication names, dosages, pill shapes, photos) is **NOT** shared with AdMob, Crashlytics, or analytics
- Firebase Crashlytics does not collect health-related data (medication names, dosages, pill shapes, photos are not included in crash reports)
- AdMob advertising ID sharing may constitute "sale" under CCPA — consider marking conservatively
- Anonymous authentication collects no personal info (no email, no name)
- All caregiver data sharing requires explicit user consent (QR code invite)
- Data retention: 30 days after account deletion for server-side cleanup
