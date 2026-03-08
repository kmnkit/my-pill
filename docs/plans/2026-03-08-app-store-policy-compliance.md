# App Store / Play Store Policy Compliance

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 앱스토어(iOS) 및 플레이스토어(Android) 정책 위반 사항 7개를 우선순위 순으로 수정하여 심사 통과 가능 상태로 만든다.

**Architecture:** 현행 코드 변경 최소화 원칙. 기존 `kPremiumEnabled` 플래그 체계를 활용하고, AdMob UMP SDK는 앱 초기화 단계에 삽입한다.

**Tech Stack:** Flutter 3.41+, google_mobile_ads v7, NSUserTrackingUsageDescription, UMP SDK (google_mobile_ads 내장), Android Manifest permissions

---

## 위반 항목 요약

| # | 항목 | 플랫폼 | 심각도 |
|---|------|--------|--------|
| 1 | Premium IAP UI가 stub과 불일치 | iOS/Android | 🔴 높음 |
| 2 | ATT 미구현 + NSUserTrackingUsageDescription 누락 | iOS | 🔴 높음 |
| 3 | AdMob UMP 동의 플로우 없음 | iOS/Android | 🔴 높음 |
| 4 | 구독 약관 문구가 iOS 전용(Apple ID 언급) | Android | 🟡 중간 |
| 5 | AD_ID 퍼미션 미선언 | Android | 🟡 중간 |
| 6 | Analytics/Sentry 수집 항목 Data Safety 공시 | iOS/Android | 🟡 중간 |
| 7 | 의료 면책 문구 부재 | iOS/Android | 🟢 낮음 |

---

## Phase 1: Premium UI 불일치 수정 (🔴)

> `kPremiumEnabled = false`인 상태에서 `/premium` 라우트가 접근 가능하고 실제 IAP가 동작하지 않아 정책 위반.

### Task 1: PremiumUpsellScreen에 kPremiumEnabled 가드 추가

**수정 파일:**
- `lib/presentation/screens/premium/premium_upsell_screen.dart`

**목적:** 화면 진입 즉시 `kPremiumEnabled == false`이면 "준비 중" 안내와 닫기 버튼만 표시.

**검증:** `flutter run` → `/premium` 진입 시 구매 UI가 보이지 않고 "준비 중" 문구 표시됨.

**커밋:** `수정: kPremiumEnabled=false일 때 프리미엄 구매 UI 비노출`

---

### Task 2: qr_invite_section의 premium 진입 경로 가드

**수정 파일:**
- `lib/presentation/screens/caregivers/widgets/qr_invite_section.dart`

**목적:** `context.push(RouteNames.premium)` 호출 전 `kPremiumEnabled` 체크. `false`이면 push 하지 않음 (또는 snackbar).

**검증:** Family 화면에서 premium 진입 경로 버튼이 `kPremiumEnabled=false`일 때 동작하지 않음.

**커밋:** `수정: qr_invite_section premium 진입 경로 플래그 가드 추가`

---

## Phase 2: iOS ATT 구현 (🔴)

> `Info.plist`에 `NSUserTrackingUsageDescription` 없음. AdMob SDK는 IDFA 접근 가능 코드를 포함하므로 Apple 심사 시 거부됨.

### Task 3: NSUserTrackingUsageDescription 추가

**수정 파일:**
- `ios/Runner/Info.plist`

**추가 키/값:**
```
NSUserTrackingUsageDescription:
  "Kusuridoki uses advertising identifiers to serve non-personalized ads and measure ad performance."
```

**검증:** `grep NSUserTrackingUsageDescription ios/Runner/Info.plist` 확인.

**커밋:** `설정: iOS NSUserTrackingUsageDescription 추가`

---

### Task 4: ATT 권한 요청 초기화 코드 작성

**수정 파일:**
- `lib/core/utils/att_service.dart` (신규)

**목적:** iOS 14.5+ 에서만 실행되는 ATT 권한 요청 래퍼.
**설계:** `static Future<void> requestIfNeeded()` — `dart:io Platform.isIOS` + `app_tracking_transparency` 패키지 또는 `google_mobile_ads`의 UMP 내장 ATT 요청 활용.

> **참고:** `google_mobile_ads v7`의 UMP SDK는 ATT를 자체 처리하므로 별도 패키지 없이 UMP 플로우(Task 6)에서 통합 처리 가능. Task 4는 UMP 선택 방식에 따라 생략 가능.

**커밋:** `기능: ATT 권한 요청 서비스 추가`

---

## Phase 3: AdMob UMP 동의 플로우 (🔴)

> EU GDPR 및 Google AdMob 정책상 UMP(User Messaging Platform) 동의 수집 필수. `google_mobile_ads v7`에 UMP SDK 내장.

### Task 5: AdConsentService 작성

**신규 파일:**
- `lib/core/utils/ad_consent_service.dart`

**설계:**
```
AdConsentService
  ├── initialize() — ConsentInformation.requestConsentInfoUpdate 호출
  ├── showFormIfRequired() — ConsentForm.loadAndShowIfRequired 호출
  └── isConsentObtained → bool
```

UMP 초기화 → 동의 필요 여부 확인 → 필요시 폼 표시 → 완료 후 MobileAds.instance.initialize() 호출.
이 순서를 지키지 않으면 AdMob 정책 위반.

**커밋:** `기능: AdConsentService (UMP 동의 플로우) 추가`

---

### Task 6: 앱 시작 시 UMP → AdMob 초기화 순서 교정

**수정 파일:**
- `lib/main.dart`
- `lib/data/services/ad_service.dart`

**현재 문제:** `AdService.initialize()`가 동의 없이 `MobileAds.instance.initialize()` 호출.

**목적:** `main()` 또는 앱 최초 진입 시 `AdConsentService.initialize()` → `showFormIfRequired()` → `AdService.initialize()` 순서 보장.

**검증:**
- 에뮬레이터에서 `ConsentDebugSettings`로 EEA 지역 강제 → 동의 폼이 첫 실행에 표시됨
- 동의 후 재실행 시 폼이 다시 표시되지 않음

**커밋:** `수정: AdMob 초기화 전 UMP 동의 수집 순서 보장`

---

## Phase 4: Android 퍼미션 & 약관 (🟡)

### Task 7: Android AD_ID 퍼미션 추가

**수정 파일:**
- `android/app/src/main/AndroidManifest.xml`

**추가:**
```xml
<uses-permission android:name="com.google.android.gms.permission.AD_ID"/>
```

**검증:** `grep AD_ID android/app/src/main/AndroidManifest.xml`

**커밋:** `설정: Android AD_ID 퍼미션 명시 선언`

---

### Task 8: 구독 약관 플랫폼 분기

**수정 파일:**
- `lib/l10n/app_en.arb`
- `lib/l10n/app_ja.arb`
- `lib/presentation/screens/premium/premium_upsell_screen.dart`의 `_buildSubscriptionTerms`

**목적:**
- iOS: 현행 "Apple ID account" 문구 유지
- Android: "Google Play account at confirmation of purchase... manage in Google Play" 문구로 교체

**설계:** `_buildSubscriptionTerms`에 `Platform.isIOS` 분기 또는 별도 l10n key (`subscriptionTermsAndroid`) 추가.

**l10n 키 추가:**
- `subscriptionTermsAndroid` — Google Play 기준 약관 문구

**검증:** Android 빌드에서 Premium 화면 하단 약관 문구가 Google Play 언급.

**커밋:** `수정: 구독 약관 iOS/Android 플랫폼별 문구 분기`

---

## Phase 5: 의료 면책 문구 (🟢)

### Task 9: 온보딩 첫 화면에 면책 문구 추가

**수정 파일:**
- `lib/l10n/app_en.arb`
- `lib/l10n/app_ja.arb`
- `lib/presentation/screens/onboarding/widgets/onboarding_welcome_step.dart`

**추가 l10n 키:**
- `medicalDisclaimer` — "This app is a reminder tool and is not intended as medical advice. Always follow your doctor's instructions."
- `medicalDisclaimerJa` — 일본어 번역

**목적:** 온보딩 welcome 스텝 하단에 작은 텍스트로 표시.

**커밋:** `기능: 온보딩 의료 면책 문구 추가`

---

## Phase 6: 비코드 작업 (스토어 콘솔)

> 코드 수정 없음. 스토어 제출 시 수동으로 입력해야 하는 항목.

### Task 10: Google Play — Data Safety 섹션 작성

Play Console → 앱 콘텐츠 → 데이터 보안:

| 수집 항목 | 목적 | 공유 여부 |
|-----------|------|-----------|
| 이름 / 이메일 | 계정 관리 | Firebase (처리자) |
| 약물 데이터, 복약 이력 | 앱 기능 | Firestore (처리자), 보호자에게 선택적 공유 |
| 앱 사용 이벤트 | 분석 | Firebase Analytics |
| 오류 리포트 + User ID | 앱 안정성 | Sentry |
| 광고 ID | 광고 (비개인화) | Google AdMob |

---

### Task 11: App Store — Privacy Nutrition Labels 작성

App Store Connect → App Privacy:

| 카테고리 | 항목 | 추적 여부 |
|----------|------|-----------|
| Contact Info | 이메일 주소 | No |
| Health & Fitness | 복약 데이터 | No |
| Identifiers | User ID | No |
| Diagnostics | Crash data | No |
| Usage Data | Product interaction (Analytics) | No |
| Identifiers | Device ID (AdMob 비개인화) | Yes → ATT 필요 |

---

## 작업 순서 요약

```
Phase 1 (premium guard)  → commit ×2
Phase 2 (ATT)            → commit ×2
Phase 3 (UMP)            → commit ×2
Phase 4 (Android)        → commit ×2
Phase 5 (disclaimer)     → commit ×1
Phase 6 (스토어 콘솔)     → 수동 작업
```

## 검증 기준

- [ ] `flutter analyze` 0 errors
- [ ] `flutter test` 전체 통과
- [ ] Android: `grep AD_ID android/app/src/main/AndroidManifest.xml`
- [ ] iOS: `grep NSUserTrackingUsageDescription ios/Runner/Info.plist`
- [ ] 에뮬레이터(EEA Debug): 첫 실행 시 UMP 동의 폼 표시
- [ ] `kPremiumEnabled=false` 상태에서 `/premium` 진입 시 구매 UI 미노출
- [ ] Android 빌드에서 구독 약관에 "Google Play" 포함
