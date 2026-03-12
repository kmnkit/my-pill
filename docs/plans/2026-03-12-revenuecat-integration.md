# RevenueCat IAP 통합 구현 계획

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** stub `SubscriptionService`를 RevenueCat SDK로 교체하여 실제 구독 구매/복원/상태 관리를 가능하게 한다.

**Architecture:** 기존 `SubscriptionService` 인터페이스(purchase, restore, status stream)를 유지하면서 내부 구현만 RevenueCat SDK(`purchases_flutter`)로 교체. RevenueCat가 영수증 검증과 구독 상태 관리를 처리하므로 기존 `CloudFunctionsService.verifyReceipt`는 불필요. Firebase Auth UID를 RevenueCat appUserID로 동기화하여 cross-platform 구독 공유.

**Tech Stack:** `purchases_flutter` (RevenueCat Flutter SDK), Firebase Auth (사용자 ID 연동)

---

## 전제 조건 (수동 설정, 코드 아님)

코드 작업 전에 다음 외부 설정이 완료되어야 한다:

### RevenueCat 대시보드
1. RevenueCat 계정 생성 → 프로젝트 생성
2. **iOS App** 등록: App Store Connect의 Shared Secret 입력
3. **Android App** 등록: Google Play Console의 Service Account JSON 연결
4. **Entitlement** 생성: identifier = `premium`
5. **Products** 등록:
   - `premium_monthly` (monthly subscription) → `premium` entitlement에 연결
   - `premium_yearly` (yearly subscription) → `premium` entitlement에 연결
6. **Offering** 생성: identifier = `default`, 위 두 product를 package로 추가
7. API Keys 복사: iOS용 `appl_xxxxx`, Android용 `goog_xxxxx`

### App Store Connect
1. 구독 상품 2개 생성: `premium_monthly`, `premium_yearly`
2. 구독 그룹 생성 및 상품 연결
3. 7일 무료 체험 설정 (선택사항, RevenueCat Offering에서도 가능)

### Google Play Console
1. 구독 상품 2개 생성: `premium_monthly`, `premium_yearly`
2. 기본 요금제(base plan) + offer 설정

### Xcode
1. Runner target → Signing & Capabilities → **"In-App Purchase"** capability 추가
   - 이 작업은 `Runner.entitlements`에 자동 반영되지 않음 — Xcode에서 직접 추가 필요

---

## File Map

| 작업 | 파일 | 역할 |
|------|------|------|
| 생성 | `lib/core/constants/revenuecat_config.dart` | RevenueCat API 키, entitlement ID 상수 |
| 수정 | `pubspec.yaml` | `purchases_flutter` 의존성 추가 |
| 수정 | `lib/data/services/subscription_service.dart` | RevenueCat SDK 연동 구현 |
| 수정 | `lib/data/providers/subscription_provider.dart` | Firebase UID → RevenueCat login 연동 |
| 수정 | `lib/main.dart` | RevenueCat SDK 초기화 |
| 수정 | `test/data/providers/subscription_provider_test.dart` | provider 테스트 업데이트 |
| 수정 | `test/data/services/subscription_service_test.dart` (있다면 생성) | 서비스 테스트 |

---

## Phase 1: 의존성 & 설정 상수

### Task 1: `purchases_flutter` 의존성 추가

**파일:** `pubspec.yaml`
**목적:** RevenueCat Flutter SDK 설치

- [ ] `dependencies`에 `purchases_flutter: ^8.0.0` 추가
- [ ] `flutter pub get` 실행
- [ ] iOS: `cd ios && pod install && cd ..`
- [ ] 검증: `flutter analyze` 통과

### Task 2: RevenueCat 설정 상수 파일 생성

**파일:** 생성 `lib/core/constants/revenuecat_config.dart`
**목적:** API 키, entitlement ID, offering ID를 상수로 관리

**내용:**
- `iosApiKey` — RevenueCat iOS API 키 (`appl_xxxxx`)
- `androidApiKey` — RevenueCat Android API 키 (`goog_xxxxx`)
- `entitlementId` — `'premium'`
- `defaultOfferingId` — `'default'`

> RevenueCat API 키는 public-safe (클라이언트 코드에 노출 가능, 공식 문서 권장). 별도 환경변수 불필요.

- [ ] 파일 생성 (API 키는 placeholder로 — 실제 키는 전제 조건 완료 후 교체)
- [ ] 검증: `flutter analyze` 통과
- [ ] 커밋: `설정: RevenueCat 의존성 및 설정 상수 추가`

---

## Phase 2: SubscriptionService RevenueCat 구현

### Task 3: SubscriptionService 재작성

**파일:** 수정 `lib/data/services/subscription_service.dart`
**목적:** stub 구현을 RevenueCat SDK 호출로 교체

**기존 public 인터페이스 유지:**
- `initialize()` → RevenueCat SDK configure + `addCustomerInfoUpdateListener`
- `purchaseMonthly()` → `Purchases.getOfferings()` → monthly package 찾기 → `Purchases.purchase()`
- `purchaseYearly()` → 동일, yearly package
- `restorePurchases()` → `Purchases.restorePurchases()`
- `status` / `isPremium` / `statusStream` → CustomerInfo에서 entitlement 확인
- `productsLoaded` / `productsLoadedStream` → offerings 로드 완료 시 emit
- `onStatusChanged` / `onPurchaseError` → 기존 콜백 유지
- `dispose()` → stream controller close

**핵심 설계 결정:**
- `Purchases.configure(PurchasesConfiguration(apiKey))` — platform별 키 분기 (`Platform.isIOS`)
- Entitlement 확인: `customerInfo.entitlements.active.containsKey('premium')`
- `SubscriptionStatus` 매핑: `CustomerInfo` → `SubscriptionStatus(isPremium, expiresAt, productId, platform)` 변환
- `SubscriptionPlatform` 매핑: `Store.appStore` → `.appStore`, `Store.playStore` → `.playStore`
- 에러 핸들링: `PurchasesErrorCode.purchaseCancelledError` → `onPurchaseError('canceled')`로 전달 (기존 UI가 'canceled'를 특별 처리)

**`_status` 필드 변경:** `final` → mutable. `_updateStatus(CustomerInfo)` 헬퍼로 갱신.

- [ ] 기존 stub 코드 제거
- [ ] `initialize()` 구현 — configure + offerings 로드 + listener 등록
- [ ] `_updateStatus(CustomerInfo)` 헬퍼 구현 — CustomerInfo → SubscriptionStatus 변환
- [ ] `purchaseMonthly()` / `purchaseYearly()` 구현 — offerings에서 package 찾아 구매
- [ ] `restorePurchases()` 구현
- [ ] 검증: `flutter analyze` 통과
- [ ] 커밋: `기능: SubscriptionService RevenueCat 구현`

### Task 4: RevenueCat 사용자 ID 연동

**파일:** 수정 `lib/data/providers/subscription_provider.dart`
**목적:** Firebase Auth 로그인/로그아웃 시 RevenueCat appUserID 동기화

**설계:**
- `subscriptionServiceProvider` 내에서 `authStateProvider` watch
- 로그인 시: `Purchases.logIn(firebaseUid)` → 구독 상태 복원
- 로그아웃 시: `Purchases.logOut()` → anonymous user로 전환
- 기존 `adService` 연동 로직 유지

- [ ] `authStateProvider` watch 추가
- [ ] 로그인/로그아웃 시 `Purchases.logIn` / `Purchases.logOut` 호출
- [ ] 검증: `flutter analyze` 통과
- [ ] 커밋: `기능: RevenueCat Firebase Auth 사용자 동기화`

### Task 5: SDK 초기화 시점 이동

**파일:** 수정 `lib/main.dart`
**목적:** 앱 시작 시 RevenueCat SDK를 초기화

**설계:**
- `SubscriptionService.initialize()`는 `Purchases.configure()`를 포함하므로, 앱 시작 시점 (`main()` 또는 `ProviderScope` 내)에서 호출되어야 함
- 현재 `subscriptionServiceProvider` 내에서 `service.initialize()` 호출 중 — 이 패턴 유지 가능
- **확인 필요:** `Purchases.configure()`가 `WidgetsFlutterBinding.ensureInitialized()` 이후에 호출되는지

- [ ] `main.dart`의 `WidgetsFlutterBinding.ensureInitialized()` 이후 호출 순서 확인
- [ ] 필요 시 초기화 순서 조정
- [ ] 검증: 앱 실행 시 RevenueCat 로그 출력 확인 (debug 모드)
- [ ] 커밋: `설정: RevenueCat 초기화 순서 정리`

---

## Phase 3: 테스트 업데이트

### Task 6: SubscriptionService 테스트

**파일:** 생성 또는 수정 `test/data/services/subscription_service_test.dart`
**목적:** RevenueCat 의존 코드의 단위 테스트

**설계:**
- RevenueCat SDK는 platform channel 기반 → 단위 테스트에서 직접 호출 불가
- `SubscriptionService`를 override 가능하도록 테스트 → 이미 provider에서 `overrideWithValue`로 주입 중
- 서비스 레벨 테스트: product ID 상수, status 매핑 로직, callback 동작 등 platform-independent 로직만 테스트
- 통합 테스트: 실기기에서만 가능 (Sandbox/TestFlight 환경)

- [ ] 서비스 상수 테스트 (product IDs, trial days)
- [ ] `_updateStatus` 매핑 로직 테스트 (CustomerInfo → SubscriptionStatus 변환이 testable하도록 설계)
- [ ] 검증: `flutter test test/data/services/subscription_service_test.dart` 통과

### Task 7: Provider 테스트 업데이트

**파일:** 수정 `test/data/providers/subscription_provider_test.dart`
**목적:** 기존 테스트가 RevenueCat 연동 후에도 통과하도록 조정

**설계:**
- 기존 테스트는 `subscriptionServiceProvider.overrideWithValue(SubscriptionService())` 사용 — stub 서비스 주입
- RevenueCat 연동 후에도 동일 패턴 유지 (테스트에서는 stub 서비스 주입)
- 필요 시 provider 내 `Purchases.logIn/logOut` 호출 부분의 mock 처리

- [ ] 기존 테스트 전체 실행 → 실패 항목 확인
- [ ] 실패 테스트 수정
- [ ] 검증: `flutter test` 전체 통과
- [ ] 커밋: `테스트: RevenueCat 통합 후 테스트 업데이트`

---

## Phase 4: 검증

### Task 8: 정적 분석 & 전체 테스트

- [ ] `flutter analyze` — 에러 0개
- [ ] `flutter test` — 기존 테스트 전체 통과
- [ ] 커밋 (필요 시)

### Task 9: 실기기 검증 (수동)

- [ ] iOS Sandbox 계정으로 구매 테스트
- [ ] Android 테스트 계정으로 구매 테스트
- [ ] 구매 후 `isPremiumProvider` = true 확인
- [ ] 광고 제거 확인 (`AdService.setAdsRemoved(true)`)
- [ ] 앱 재시작 후 구독 상태 유지 확인
- [ ] `restorePurchases` 동작 확인

---

## Devil's Advocate Review

- **도전한 가정:** RevenueCat API 키를 코드에 하드코딩해도 안전한가? → RevenueCat 공식 문서에서 "public API key"로 명시, 클라이언트 노출 설계. `--dart-define`은 불필요한 복잡성.
- **검토한 대안:** `in_app_purchase` (Flutter 공식) — 영수증 검증 직접 구현 필요, 서버 운영 비용. RevenueCat 채택 이유: 무료 tier 충분 ($2.5M 매출까지), 영수증 검증 자동, 대시보드 제공.
- **식별된 리스크:**
  1. RevenueCat SDK가 test 환경에서 `MissingPluginException` 발생 가능 → provider override로 완화 (기존 패턴)
  2. `Purchases.configure()`를 `subscriptionServiceProvider` 내에서 호출하면 provider가 recreate될 때 재초기화 위험 → `initialize()`에서 이미 configure 여부 체크 또는 `main.dart`로 이동
  3. 전제 조건(스토어 상품 등록)이 완료되지 않으면 코드만으로는 테스트 불가 → Phase 4의 실기기 검증은 전제 조건 완료 후
- **결론:** 기존 인터페이스를 유지하면서 내부만 교체하는 접근이 최선. UI/Provider 변경 최소화.
