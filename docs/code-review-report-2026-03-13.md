# kusuridoki 전체 코드 리뷰 종합 리포트

**날짜**: 2026-03-13
**범위**: 전체 코드베이스 (~27K LOC, 163 소스 파일, 119 테스트 파일)
**리뷰 차원**: 10개 (보안, 아키텍처, 성능, 테스트, 의존성, 미커밋 변경, 코드 품질, 에러 핸들링, 로컬라이제이션, 접근성)

---

## 요약 통계

| 심각도 | 건수 |
|--------|------|
| CRITICAL | 4 |
| HIGH | 19 |
| MEDIUM | 38 |
| LOW | 18 |
| **합계** | **79** |

---

## CRITICAL (4건)

### C1. Sentry 스크린샷에 PHI(의료정보) 포함 전송
- **위치**: `main.dart:33` — `options.attachScreenshot = true`
- **차원**: 보안
- **설명**: 크래시 시 활성 화면의 스크린샷이 Sentry로 전송. 투약 화면(약 이름, 용량, 사진, 스케줄)이 캡처됨. `sentry_scrubber.dart`는 extras/user만 처리하고 screenshot attachment은 미처리.
- **수정**: `attachScreenshot = false` 설정, 또는 `beforeSend` 콜백에서 `hint.screenshot = null` 처리.

### C2. Sentry 세션 리플레이에 PHI 마스킹 미설정
- **위치**: `main.dart:38-40` — replay `onErrorSampleRate = 1.0`
- **차원**: 보안
- **설명**: 주석에 "all text/images masked by default"라고 되어 있으나 실제 `maskAllText`/`maskAllImages` 설정 코드 없음. `SentryMask` 위젯 사용도 0건. 100% 에러 세션에서 투약 데이터가 포함된 비디오 리플레이가 Sentry로 전송.
- **수정**: 의료 앱에서 replay 비활성화하거나, `options.replay.maskAllText = true` + `options.replay.maskAllImages = true` 명시 설정.

### C3. PHI 스크러버 불완전 커버리지
- **위치**: `sentry_scrubber.dart:11-35`
- **차원**: 보안
- **설명**: 4개 하드코딩 키(`medicationName`, `dosage`, `pillColor`, `pillShape`)만 extras에서 제거. breadcrumb, screenshot, view hierarchy, exception toString() 내 PHI 미처리. Freezed 모델의 auto-generated toString()에 투약 데이터 포함 가능.
- **수정**: screenshot/view hierarchy 제거, breadcrumb 정리, extras 기본 전수 드롭 또는 allowlist 확장.

### C4. Firebase 초기화 실패 무시 → 전체 기능 연쇄 실패
- **위치**: `main.dart:54-58`
- **차원**: 에러 핸들링
- **설명**: `catch (e) { debugPrint(...) }` — Firebase 실패 후 앱이 정상 실행되나 Auth/Firestore/Functions/FCM 전부 실패. 사용자에게 무표시, Sentry 보고 없음.
- **수정**: `ErrorHandler.captureException` 호출 + 사용자에게 degraded mode 알림 또는 재시도 UI 표시.

---

## HIGH (19건)

### 보안 (2건)

| # | 이슈 | 위치 |
|---|------|------|
| H1 | `sendDefaultPii=true` — IP, 디바이스 ID, HTTP 헤더 자동 수집 | `main.dart:27` |
| H2 | AdMob 프로덕션 광고 단위 ID 하드코딩 (publisher ID 노출) | `ad_service.dart:27-28` |

### 아키텍처 — DIP 위반 (3건)

| # | 이슈 | 위치 | 건수 |
|---|------|------|------|
| H3 | `StorageService()` presentation에서 직접 생성 | settings_screen, caregiver_settings_screen, account_section | 10회 |
| H4 | `CloudFunctionsService()` presentation에서 직접 생성 | settings_screen, caregiver_settings_screen | 3회 |
| H5 | `AdService()` presentation에서 직접 생성 | home_screen, medications_list_screen, premium_upsell_screen | 4회 |

### 성능 (3건)

| # | 이슈 | 위치 |
|---|------|------|
| H6 | `subscription_provider.dart:26` fire-and-forget `initialize()` — 프리미엄 상태 경쟁 조건 | `subscription_provider.dart:26` |
| H7 | `addCustomerInfoUpdateListener` 미해제 — provider 재생성 시 리스너 누적 | `subscription_service.dart:49` |
| H8 | BannerAd 이중 소유권 — 위젯 dispose 후 AdService가 stale 참조 보유 (use-after-dispose) | `home_screen.dart:43`, `ad_service.dart:53` |

### 의존성 (2건)

| # | 이슈 | 위치 |
|---|------|------|
| H9 | `flutter_local_notifications: ^21.0.0-dev.2` — 프로덕션에서 pre-release 버전 | `pubspec.yaml:32` |
| H10 | `google_sign_in: ^7.2.0` — lib/에서 import 0건, 완전 미사용 | `pubspec.yaml:41` |

### 코드 품질 (3건)

| # | 이슈 | 위치 |
|---|------|------|
| H11 | PremiumUpsellScreen SRP 위반 — 구매 로직/스트림 관리/광고 상태/UI 4개 책임 혼재 (681줄) | `premium_upsell_screen.dart` |
| H12 | `StorageService().clearUserData()` 8회 반복 (DRY 위반 + DIP 위반) | 3개 파일 |
| H13 | `_invalidateUserProviders` 동일 7-provider 목록 2곳 중복, 총 9회 호출 | settings_screen, caregiver_settings_screen |

### 미커밋 변경 (1건)

| # | 이슈 | 위치 |
|---|------|------|
| H14 | `build()` 내 `_bannerAd = null` 상태 변이 — Flutter 안티패턴, double-dispose 부분 완화만 | `home_screen.dart:53`, `medications_list_screen.dart:64` |

### 에러 핸들링 (3건)

| # | 이슈 | 위치 |
|---|------|------|
| H15 | `e.toString()` 사용자 SnackBar에 직접 노출 — 8곳 | login_screen, premium_upsell_screen, backup_sync_dialog, family_screen, subscription_service |
| H16 | `restorePurchases` 비-Platform 에러 무시 — 사용자 피드백 없음 | `subscription_service.dart:163-165` |
| H17 | `initialize()` 실패 후 `_productsLoaded = true` → broken state, 구매 버튼 무반응 | `subscription_service.dart:59-66` |

### 로컬라이제이션 (1건)

| # | 이슈 | 위치 |
|---|------|------|
| H18 | ReportService PDF 전체 영어 하드코딩 (20+ 문자열) — 일본어 사용자에게 영어 PDF 제공 | `report_service.dart` 전체 |

### 접근성 (1건)

| # | 이슈 | 위치 |
|---|------|------|
| H19 | 다크모드 snooze 칩 텍스트 보이지 않음 — `AppColors.textPrimary`(#111817) on `cardDark`(#1E3330), 대비비 ~1.4:1 | `notification_settings.dart:91` |

---

## MEDIUM (38건)

### 보안 (3건)
- 보호자 환자 데이터 클라이언트측 인가 미검증 (`firestore_service.dart:191-215`)
- 리포트 PDF를 temp 디렉토리에 암호화 없이 저장 (`report_service.dart:57-62`)
- View hierarchy attachment에 PHI 위젯 텍스트 포함 (`main.dart:35`)

### 아키텍처 (4건)
- `FirestoreService()` 직접 생성 1건 (`backup_sync_dialog.dart:54`)
- `FirebaseAuth.instance` 직접 접근 7건 (settings_screen, caregiver_settings_screen, backup_sync_dialog, app_router_provider)
- 하드코딩 라우트 경로 30건 vs RouteNames 사용 2건 (14개 파일)
- Data 서비스 import 13건 in presentation (9개 파일)

### 성능 (4건)
- `ad_provider.dart:9` 중복 fire-and-forget initialize (사실상 dead code)
- BannerAd 생애주기 코드 home_screen ↔ medications_list_screen 반복
- 리마인더 생성/스케줄링 `app.dart` 내 중복 + 동시 실행 위험
- PremiumUpsellScreen이 singleton 서비스에 글로벌 콜백 설정 + provider 우회

### 테스트 (5건)
- 핵심 서비스 테스트 부재: report_service(391줄), review_service(63줄), home_widget_service(110줄)
- 핵심 화면 테스트 부재: premium_upsell_screen(681줄), family_screen, caregiver_settings_screen, edit_medication_screen, splash_screen
- Render-only 테스트: weekly_summary_screen, caregiver_dashboard_screen, home_screen (행동 검증 없음)
- 화면 서브위젯 25% 커버리지 (28개 중 21개 미테스트)
- home_widget_provider 멀티 프로바이더 오케스트레이션 미테스트

### 의존성 (3건)
- `printing: ^5.14.2` 완전 미사용
- `cloud_functions_platform_interface: any` 제약
- `hive: ^2.2.3` 유지보수 중단

### 미커밋 변경 (3건)
- `_lastUserId` 캐싱이 실패 시 재시도 차단 (`subscription_service.dart:140-141`)
- `RouteNames.premium` → `'/premium'` 하드코딩 회귀 (`qr_invite_section.dart:133`)
- `Future.wait` 타입 안전성 소실 (`subscription_service.dart:53-58`)

### 코드 품질 (5건)
- Sign-out/delete-account 3-step 흐름 2개 파일 중복 (SRP+DRY)
- BannerAd 패턴 2개 화면 중복
- Adherence stats 계산 ReportService 내 6회 반복
- `isAnonymous` try/catch 패턴 4회 반복
- ShellScreen 2개 동일 위젯 (enum 1개만 차이)

### 에러 핸들링 (5건)
- 31개 catch 블록이 `debugPrint`만 사용 (프로덕션 가시성 0)
- `ErrorHandler.getErrorCode` 문자열 매칭 기반 → 분류 오류 가능
- `app.dart` 핵심 리마인더/알림 액션 에러 무시 (3곳)
- `login_screen.dart:91` displayName 업데이트 에러 완전 무시 `catchError((_) {})`
- 앱 레벨 에러 바운더리 없음 (FlutterError.onError, ErrorWidget.builder 미설정)

### 로컬라이제이션 (4건)
- "MyPill" 잘못된 앱 이름 참조 (EN/JA 양쪽)
- JA "介護者"/"サポーター" 용어 불일치 (3곳)
- 하드코딩 "OK", "Email", "Code:" (3곳)
- `report_service.dart` 영어 전용 날짜 포맷

### 접근성 (9건)
- QR 코드 이미지 Semantics 없음
- 공유 버튼(Link/LINE/Email/SMS) Semantics 없음
- KdAlertBanner Semantics 없음
- KdRadioOption Semantics 없음
- KdToggleSwitch 터치 타겟 28px (최소 44px 미달)
- 인벤토리 카운트 최소 탭 영역 미설정
- `AppColors.primary` (#0D968B) 텍스트 대비비 부족 (3.5:1, AA 미달)
- `AppColors.warning` (#F59E0B) 텍스트 대비비 부족 (2.1:1, AA 미달)
- IconButton 11개 중 8개 tooltip 누락
- 약 추가 화면 유효성 검증이 SnackBar만 (inline 에러 없음)

---

## LOW (18건)

<details>
<summary>전체 LOW 이슈 목록 (클릭하여 펼치기)</summary>

### 보안 (1건)
- 암호화 키 `KeychainAccessibility.first_unlock` — 생체인증 미설정

### 의존성 (3건)
- `collection: ^1.19.1` 중복 선언 (Freezed 생성 코드만 사용)
- `shimmer: ^3.0.0` 업데이트 부족
- `home_widget: ^0.9.0` pre-1.0 버전

### 아키텍처 (1건)
- `app_router_provider.dart:206` `FirebaseAuth.instance` (computeRedirect로 완화)

### 성능 (2건)
- `setState(() {})` 빈 body (ad 로드 전 불필요한 rebuild)
- `isPremiumProvider`가 전체 서비스 객체 watch (.select() 미사용)

### 미커밋 변경 (2건)
- `report.xml` fastlane 빌드 아티팩트 gitignore 누락
- `formatDate`가 `TimezoneUtils`에 위치 (의미적 불일치)

### 코드 품질 (3건)
- `kPremiumEnabled` dead branches 9곳
- `_hideAdsForScreenshots = false` 주석 불일치
- StorageService deserialize 패턴 9회 반복 (안정적이라 우선순위 낮음)

### 에러 핸들링 (2건)
- `debugLog` vs `captureException` 사용 가이드라인 부재
- AdService init 실패 미보고

### 로컬라이제이션 (2건)
- "+30"/"+90" 수치 라벨 (언어 중립이라 수용 가능)
- "N/A" 하드코딩 (`patient_data_card.dart:40`)

### 접근성 (4건)
- 장식용 아이콘 semanticLabel/excludeFromSemantics 미설정
- 약 사진 Image semanticLabel 미설정
- `textMuted` (#618986) 일반 텍스트 대비비 3.7:1 (AA 4.5:1 미달)
- KdColorDot 기본 size 36px (사용처에서 44로 override하므로 실질 영향 없음)

</details>

---

## 수정 우선순위 권장

### 즉시 수정 (커밋 전)

1. **C1+C2+C3**: Sentry PHI 유출 차단 — `attachScreenshot = false`, replay 비활성화 또는 마스킹 명시
2. **C4**: Firebase init 실패 시 `ErrorHandler.captureException` + degraded mode 표시
3. **H14**: `build()` 내 상태 변이 → `ref.listen` + `setState` 패턴으로 교체
4. **H15**: `e.toString()` SnackBar → 사용자 친화적 에러 메시지로 교체

### 단기 (1-2주)

5. **H3-H5**: 서비스 직접 생성 18건 → `ref.read(xxxProvider)` 전환
6. **H6+H7**: `subscriptionServiceProvider`를 `AsyncNotifierProvider`로 전환, 리스너 해제 추가
7. **H8**: BannerAd 소유권 단일화 (AdService 또는 위젯 중 하나만 소유)
8. **H9**: `flutter_local_notifications` stable 버전으로 전환
9. **H10**: `google_sign_in` 제거
10. **H19**: 다크모드 snooze 칩 텍스트 색상 수정

### 중기 (1개월)

11. **H11**: PremiumUpsellScreen 분해 (PurchaseNotifier 추출)
12. **H12+H13**: clearUserData/invalidateProviders 공통 유틸리티 추출
13. 하드코딩 라우트 30건 → RouteNames 전환
14. `debugPrint` catch 블록 31건 → `ErrorHandler.captureException` 전환
15. ReportService l10n 지원
16. 핵심 서비스 테스트 추가 (report_service, review_service, home_widget_service)

### 장기 (백로그)

17. Hive → 대체 스토리지 마이그레이션 계획
18. 접근성 MEDIUM 이슈 일괄 개선
19. 화면 서브위젯 테스트 커버리지 확대
20. `ErrorHandler` 가이드라인 문서화

---

## 긍정적 발견

- **데이터 레이어 테스트 100%**: models, enums, repositories 전수 테스트
- **Hive 암호화**: FlutterSecureStorage로 키 관리, AES 암호화 적용
- **접근성 기초**: 공유 위젯 레이어에 Semantics 체계적 적용, 고대비 테마 4종, 텍스트 크기 3단계
- **l10n 키 완전 일치**: EN/JA 687개 키 100% 동기화, placeholder 일관성 양호
- **Firestore 보안 규칙**: 서버측 caregiverAccess 인가 적용
- **미커밋 변경**: YAGNI 정리(PremiumGate 삭제, l10n 키 4개 삭제) 깔끔하게 수행, 고아 참조 없음
- **Riverpod 인프라**: provider가 이미 모든 서비스에 존재 — DIP 위반은 인프라 부재가 아닌 사용 불일치
