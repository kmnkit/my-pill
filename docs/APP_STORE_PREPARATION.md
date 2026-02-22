# Kusuridoki (くすりどき) - App Store 출시 준비 종합 가이드

**최종 업데이트:** 2026-02-22
**앱 버전:** 1.0.0+1
**Bundle ID:** `com.ginger.mypill`
**지원 언어:** English (en), Japanese (ja)

---

## 목차

1. [현재 상태 요약](#1-현재-상태-요약)
2. [스크린샷 전략](#2-스크린샷-전략)
3. [App Store Connect 메타데이터](#3-app-store-connect-메타데이터)
4. [App Privacy (개인정보 처리)](#4-app-privacy-개인정보-처리)
5. [기술적 준비 사항](#5-기술적-준비-사항)
6. [제출 전 체크리스트](#6-제출-전-체크리스트)
7. [심사 리젝 대비](#7-심사-리젝-대비)
8. [출시 후 계획](#8-출시-후-계획)

---

## 1. 현재 상태 요약

### 완료된 항목

| 항목 | 상태 | 비고 |
|------|------|------|
| Sign in with Apple 구현 | DONE | OAuth credential + nonce 흐름 완료 |
| Google Sign-In 구현 | DONE | Firebase Auth 연동 |
| Anonymous 로그인 | DONE | 온보딩 통합 |
| 온보딩 플로우 리팩토링 | DONE | Apple/Google/Anonymous 통합 |
| l10n (EN/JA) | DONE | 용어 통일, 자연스러운 표현 수정 완료 |
| iOS 앱 아이콘 | DONE | 경로 변경 및 업데이트 완료 |
| Runner.entitlements | DONE | Sign in with Apple + Push Notifications |
| PrivacyInfo.xcprivacy | DONE | 데이터 수집/API 접근/추적 도메인 선언 |
| Info.plist 권한 | DONE | 카메라, 사진, 추적, Face ID, 알림 (6개) |
| 의존성 업그레이드 | DONE | 20개 패키지 minor/patch 업그레이드 |
| Firebase OAuth 크래시 수정 | DONE | disposed ref 에러 수정 |
| CI/CD (GitHub Actions) | DONE | analyze + test + coverage |

### 미완료 항목 (수동 작업 필요)

| 항목 | 우선순위 | 설명 |
|------|---------|------|
| Xcode Team 서명 설정 | CRITICAL | Apple Developer Team 연결 |
| App Store Connect 앱 등록 | CRITICAL | 앱 생성 + 메타데이터 입력 |
| 스크린샷 촬영 | CRITICAL | 최소 3장/언어, 권장 6장/언어 |
| Privacy Policy URL | CRITICAL | 앱 내 + 스토어 메타데이터 모두 필요 |
| Support URL | CRITICAL | 지원 페이지 또는 이메일 주소 |
| 데모 계정 준비 | HIGH | 심사 리뷰어용 |
| Release 빌드 테스트 | CRITICAL | 실기기에서 flutter run --release |
| TestFlight 내부 테스트 | HIGH | 제출 전 최소 1회 |

---

## 2. 스크린샷 전략

### 2.1 필수 사양

| 디바이스 | 해상도 | 필수 여부 |
|---------|--------|----------|
| iPhone 6.7" (15 Pro Max) | 1290 x 2796 px | **필수** |
| iPhone 6.5" (11 Pro Max) | 1242 x 2688 px | 권장 |
| iPhone 5.5" (8 Plus) | 1242 x 2208 px | 선택 |
| iPad 12.9" (6th gen) | 2048 x 2732 px | iPad 지원 시 필수 |

- **포맷:** PNG 또는 JPEG
- **수량:** 언어당 최소 3장, 최대 10장
- **권장:** 6장 (핵심 기능을 모두 커버)

### 2.2 권장 스크린샷 시퀀스 (6장)

앱의 핵심 가치를 순서대로 전달하는 구성:

#### Screenshot 1: 홈 화면 - 오늘의 복약 타임라인

**화면:** `HomeScreen` (GreetingHeader + MedicationTimeline + LowStockBanner)
**캡션 (EN):** "Never miss a dose — your daily medication timeline at a glance"
**캡션 (JA):** "飲み忘れゼロへ — 今日の服薬スケジュールを一目で確認"
**촬영 팁:**
- 2~3개의 약이 타임라인에 등록된 상태
- 하나는 "복용 완료", 하나는 "다음 예정", 하나는 "미복용"으로 다양한 상태 표시
- 인사말 헤더에 이름이 표시되도록 설정 (예: "Good morning, Yuki")
- 재고 부족 배너가 보이면 더 좋음

#### Screenshot 2: 약 추가 화면 - 직관적인 등록

**화면:** `AddMedicationScreen` (PillShapeSelector + PillColorPicker + InventoryEditor)
**캡션 (EN):** "Add medications easily with shape, color, and schedule"
**캡션 (JA):** "形・色・スケジュールで簡単に薬を登録"
**촬영 팁:**
- 약 이름, 용량이 입력된 상태
- 약 모양(PillShape)과 색상(PillColor)이 선택된 상태
- 재고 수량이 입력된 상태
- 스크롤하여 스케줄 타입 선택기도 보이면 이상적

#### Screenshot 3: 복약 준수율 - 주간 요약

**화면:** `WeeklySummaryScreen` (OverallScore + AdherenceChart + MedicationBreakdown)
**캡션 (EN):** "Track your adherence with weekly insights and charts"
**캡션 (JA):** "週間レポートとチャートで服薬率をチェック"
**촬영 팁:**
- 전체 준수율 스코어가 80%+ 로 표시 (긍정적 인상)
- 주간 차트(fl_chart)에 데이터가 채워진 상태
- 약별 분석(MedicationBreakdown)이 보이도록 스크롤

#### Screenshot 4: 보호자 연동 - 가족 케어

**화면:** `FamilyScreen` (QR 초대 + CaregiverListTile + PrivacyNotice)
**캡션 (EN):** "Connect with family — caregivers can monitor in real-time"
**캡션 (JA):** "家族とつながる — 保護者がリアルタイムで見守り"
**촬영 팁:**
- QR 코드 초대 섹션이 보이도록
- 1~2명의 보호자가 연결된 상태
- 프라이버시 안내 문구가 하단에 보이면 신뢰감 UP

#### Screenshot 5: 트래블 모드 - 시차 자동 대응

**화면:** `TravelModeScreen` (LocationDisplay + TimezoneModeSelector + AffectedMedList)
**캡션 (EN):** "Travel worry-free — smart timezone adjustment for your meds"
**캡션 (JA):** "旅先でも安心 — 時差に合わせて服薬時間を自動調整"
**촬영 팁:**
- 트래블 모드 ON 상태
- 현재 위치와 홈 타임존이 표시된 상태
- "Fixed Interval" / "Local Time" 선택기가 보이도록
- 영향받는 약 목록이 1~2개 표시

#### Screenshot 6: 설정 화면 - 다국어 + 알림 커스터마이징

**화면:** `SettingsScreen` (AccountSection + LanguageSelector + NotificationSettings)
**캡션 (EN):** "Personalize notifications, language, and privacy settings"
**캡션 (JA):** "通知・言語・プライバシーを自分好みにカスタマイズ"
**촬영 팁:**
- 계정 섹션에 로그인된 상태 (Apple 또는 Google 아바타)
- 언어 선택기에서 English/日本語 전환 가능함을 보여주기
- 알림 설정이 ON 상태

### 2.3 스크린샷 촬영 가이드

```bash
# 1. 시뮬레이터에서 촬영 (6.7인치)
xcrun simctl boot "iPhone 15 Pro Max"
flutter run -d "iPhone 15 Pro Max"

# 2. 시뮬레이터 스크린샷 캡처
# macOS: Cmd + S (시뮬레이터 포커스 상태에서)
# 또는 CLI:
xcrun simctl io booted screenshot ~/Desktop/screenshot_1_home.png

# 3. 모든 시나리오별로 데이터를 미리 세팅한 후 캡처
# 4. EN/JA 각각 언어 전환 후 동일 화면 캡처
```

### 2.4 스크린샷 프레이밍 (선택 사항)

스토어에서 더 눈에 띄려면 디바이스 프레임 + 캡션을 추가:
- **도구:** Figma, Shotbot, AppScreens, LaunchMatic
- **스타일:** 앱 테마 색상(Teal/Blue 계열) 배경 + 흰색 캡션 텍스트
- **폰트:** 깔끔한 산세리프 (SF Pro, Noto Sans JP)

---

## 3. App Store Connect 메타데이터

### 3.1 기본 정보

| 필드 | English | Japanese |
|------|---------|----------|
| **App Name** | Kusuridoki | くすりどき |
| **Subtitle** | Your medication reminder companion | あなたの服薬リマインダー |
| **Category** | Medical (Primary), Health & Fitness (Secondary) | 메디컬 (Primary), ヘルスケア (Secondary) |
| **Age Rating** | 4+ | 4+ |
| **Price** | Free (IAP 포함) | 無料 (アプリ内課金あり) |

### 3.2 앱 설명 (Description)

**English:**
```
Kusuridoki is a smart medication management app designed to help you never miss a dose.

Whether you manage daily supplements, chronic condition medications, or complex multi-drug schedules, Kusuridoki keeps you on track with timely reminders and intuitive tracking.

KEY FEATURES:

Medication Reminders
Set personalized reminders for each medication. Get push notifications at the exact time, with snooze and skip options.

Adherence Tracking
Check off doses as you take them. Review your weekly adherence score with beautiful charts and per-medication breakdowns.

Inventory Management
Track your pill count automatically. Receive low-stock alerts so you never run out unexpectedly.

Caregiver Connection
Invite family members or caregivers to monitor your medication adherence in real-time. Share via QR code or invite link. Revoke access anytime.

Travel Mode
Traveling across time zones? Choose between fixed-interval dosing (maintain home schedule) or local-time adaptation. Your medications adjust with you.

Multilingual Support
Seamlessly switch between English and Japanese within the app.

Privacy First
Your health data stays secure. Caregivers only see what you allow. Revoke access with one tap.

MEDICAL DISCLAIMER:
Kusuridoki does not replace professional medical advice. Always consult your healthcare provider before starting, stopping, or changing medications.
```

**Japanese:**
```
くすりどきは、薬の飲み忘れを防ぐスマートな服薬管理アプリです。

毎日のサプリメントから慢性疾患の薬、複雑な服薬スケジュールまで、タイムリーなリマインダーと直感的な記録で服薬習慣をサポートします。

主な機能：

服薬リマインダー
薬ごとにリマインダーを設定。指定時間にプッシュ通知でお知らせ。スヌーズ・スキップにも対応。

服薬記録・分析
服薬したらチェック。週間スコアと薬ごとの詳細分析をチャートで確認できます。

在庫管理
薬の残量を自動追跡。在庫が少なくなるとアラートでお知らせ。急な不足を防ぎます。

保護者・家族の見守り
家族や保護者を招待して、リアルタイムで服薬状況を共有。QRコードまたは招待リンクで簡単接続。アクセス権はいつでも取り消し可能。

トラベルモード
海外旅行中の時差に対応。「固定間隔（自宅時間基準）」または「現地時間適応」を選択できます。

多言語対応
アプリ内で英語・日本語をワンタップで切り替え。

プライバシー優先
健康データは安全に保護。保護者に共有する範囲はあなたが決めます。

医療免責事項：
くすりどきは専門的な医療相談の代替となるものではありません。薬の服用開始・中止・変更の前に、必ず医療提供者にご相談ください。
```

### 3.3 키워드 (100자 이내, 쉼표 구분)

**English:**
```
medication,pill,reminder,health,tracker,adherence,caregiver,inventory,travel,timezone
```

**Japanese:**
```
薬,服薬,リマインダー,健康,記録,在庫,保護者,見守り,旅行,時差
```

### 3.4 What's New (릴리즈 노트)

**English:**
```
Version 1.0.0 — Initial Release

Welcome to Kusuridoki! Your smart medication companion.

- Medication reminders with push notifications
- Weekly adherence tracking with charts
- Inventory management with low-stock alerts
- Caregiver connection via QR code
- Travel mode with timezone support
- English and Japanese language support

We'd love to hear your feedback!
```

**Japanese:**
```
バージョン 1.0.0 — 初回リリース

くすりどきへようこそ！スマートな服薬管理パートナーです。

- プッシュ通知による服薬リマインダー
- チャート付き週間服薬記録
- 在庫不足アラート付き在庫管理
- QRコードで保護者とかんたん接続
- 時差対応トラベルモード
- 英語・日本語対応

ご意見・ご感想をお待ちしています！
```

### 3.5 Support / Marketing URLs

| 항목 | 필요 여부 | 내용 |
|------|----------|------|
| **Privacy Policy URL** | **필수** | 웹페이지 또는 GitHub Pages로 호스팅 |
| **Support URL** | **필수** | 지원 페이지 또는 `mailto:` 링크 |
| **Marketing URL** | 선택 | 앱 소개 랜딩 페이지 |

> **Privacy Policy가 없으면 심사 통과 불가.** Firebase Analytics, AdMob, Crashlytics 등 데이터 수집 SDK 사용 시 반드시 필요.

---

## 4. App Privacy (개인정보 처리)

App Store Connect에서 입력해야 하는 App Privacy 질문 응답:

### 4.1 수집하는 데이터 유형

| 데이터 유형 | 수집 여부 | 용도 | 사용자 연결 | 추적 |
|------------|----------|------|-----------|------|
| Health & Fitness (복약 기록) | YES | App Functionality | YES | NO |
| Contact Info (이메일) | YES | App Functionality | YES | NO |
| Photos | YES | App Functionality | YES | NO |
| Identifiers (IDFA) | YES | Third-Party Advertising | NO | YES |
| Usage Data | YES | Analytics | NO | NO |
| Diagnostics (Crashlytics) | YES | App Functionality | NO | NO |

### 4.2 PrivacyInfo.xcprivacy (이미 완료)

파일 위치: `ios/Runner/PrivacyInfo.xcprivacy`
- 데이터 수집 선언 완료
- API 접근 이유 선언 완료 (UserDefaults, File timestamp, System boot time)
- 추적 도메인 선언 완료 (googleadservices.com, google.com, doubleclick.net)

### 4.3 ATT (App Tracking Transparency)

- `NSUserTrackingUsageDescription`이 Info.plist에 추가됨
- AdMob 사용으로 ATT 팝업 표시 필요
- ATT 거부 시에도 앱이 정상 동작하는지 확인 필요

---

## 5. 기술적 준비 사항

### 5.1 Release 빌드 검증

```bash
# 1. 클린 빌드
flutter clean && flutter pub get

# 2. 코드 생성
dart run build_runner build --delete-conflicting-outputs

# 3. l10n 생성
flutter gen-l10n

# 4. 정적 분석
flutter analyze --fatal-infos

# 5. 테스트
flutter test

# 6. iOS Pod 설치
cd ios && rm -rf Pods Podfile.lock && pod install --repo-update && cd ..

# 7. Release 빌드 (실기기 연결 상태에서)
flutter run --release

# 8. Archive
open ios/Runner.xcworkspace
# Xcode > Product > Archive
```

### 5.2 Release 빌드에서 확인할 항목

| 항목 | 확인 방법 | 주의 사항 |
|------|----------|----------|
| 앱 크래시 없음 | 모든 화면 전환 테스트 | Debug에서 OK여도 Release에서 크래시 가능 |
| Sign in with Apple | 실기기에서 로그인 | 시뮬레이터에서는 불완전 |
| Google Sign-In | 실기기에서 로그인 | `google-services.json` 필요 |
| 푸시 알림 | 실기기에서 알림 수신 확인 | 시뮬레이터 미지원 |
| 카메라/사진 권한 | 약 사진 촬영/선택 | 권한 거부 시 graceful handling |
| 인앱 결제 | Sandbox 계정으로 테스트 | App Store Connect에 IAP 등록 필요 |
| AdMob 광고 | 테스트 광고 표시 확인 | 실제 광고 ID 설정 필요 |
| 딥링크 | 초대 링크 동작 확인 | Associated Domains 설정 |
| 다국어 전환 | EN ↔ JA 설정 변경 | 모든 문자열 확인 |

### 5.3 버전 관리

```yaml
# pubspec.yaml
version: 1.0.0+1
# 형식: MAJOR.MINOR.PATCH+BUILD_NUMBER
# 재제출 시: 1.0.0+2 (빌드 번호만 증가)
```

### 5.4 인앱 결제 (IAP) 설정

App Store Connect에서 IAP 상품 등록 필요:

| 상품 | 유형 | 설명 |
|------|------|------|
| 광고 제거 (월간) | Auto-Renewable Subscription | 월 구독으로 광고 제거 |
| 광고 제거 (연간) | Auto-Renewable Subscription | 연 구독으로 광고 제거 (할인) |

- Subscription Group 생성 필요
- 가격표(Price Tier) 설정
- 심사용 스크린샷 첨부
- **Restore Purchases 버튼 필수** (없으면 리젝)

---

## 6. 제출 전 체크리스트

### 6.1 Apple 필수 요구사항

- [ ] **Privacy Policy URL** — 앱 내 + 스토어 메타데이터 양쪽에 표시
- [ ] **Account Deletion** — Sign in with Apple/Google 로그인 시 계정 삭제 기능 제공 (Settings > Account Section에서 확인)
- [ ] **Sign in with Apple** — 소셜 로그인 제공 시 Apple 로그인 필수
- [ ] **iOS 권한 설명** — `NS*UsageDescription`에 구체적 이유 명시 (완료)
- [ ] **IAP는 Apple IAP 사용** — 외부 결제 링크 없음
- [ ] **Restore Purchases** — 구독 복원 버튼 존재
- [ ] **ATT 팝업** — 광고 추적 시 ATT 동의 요청

### 6.2 메타데이터

- [ ] 앱 이름: Kusuridoki (EN), くすりどき (JA)
- [ ] 서브타이틀: 30자 이내
- [ ] 설명: 기능 나열 + 의료 면책 조항
- [ ] 키워드: 100자 이내
- [ ] 스크린샷: 6.7" 기준 최소 3장/언어
- [ ] 앱 아이콘: 1024x1024 (alpha 없음, 둥근 모서리 자동 적용)
- [ ] 카테고리: Medical (Primary)
- [ ] 연령 등급: 4+
- [ ] What's New (릴리즈 노트)
- [ ] Privacy Policy URL
- [ ] Support URL

### 6.3 기술

- [ ] `flutter analyze --fatal-infos` 통과
- [ ] `flutter test` 전체 통과
- [ ] Release 모드 실기기 테스트 (크래시/화이트스크린 없음)
- [ ] Xcode Archive 성공
- [ ] Xcode Validate App 통과
- [ ] TestFlight 내부 테스트 최소 1회
- [ ] 빌드 번호 정확한지 확인 (`1.0.0+N`)

### 6.4 심사 리뷰어 대비

- [ ] 데모 계정 준비 (이메일 + 비밀번호)
- [ ] 리뷰 노트 작성 (앱 사용법 간략 설명)
- [ ] 특수 기능 설명 (트래블 모드, 보호자 연동 등)

---

## 7. 심사 리젝 대비

### 7.1 자주 발생하는 리젝 사유와 대응

| 리젝 사유 | Guideline | 대응 방법 |
|----------|-----------|----------|
| Sign in with Apple 미작동 | 4.8 | Entitlements 확인, 실기기 테스트 |
| 계정 삭제 기능 없음 | 5.1.1(v) | Settings > 계정 삭제 구현 확인 |
| Privacy Policy 누락 | 5.1.1 | URL 호스팅 + 앱 내 링크 추가 |
| 권한 설명 불충분 | 5.1.1 | Info.plist 문구 구체화 |
| 앱 크래시 | 2.1 | Release 빌드 실기기 테스트 |
| IAP Restore 없음 | 3.1.1 | Restore Purchases 버튼 확인 |
| 비공개 API 사용 | 2.5.1 | Flutter 버전 GitHub 이슈 확인 |
| 메타데이터 부정확 | 2.3.7 | 스크린샷과 실제 앱 일치 확인 |
| 의료 면책 조항 누락 | 1.4.1 | 앱 설명 + 앱 내에 면책 조항 표시 |

### 7.2 리뷰 노트 작성 예시

```
Demo Account:
- Email: reviewer@kusuridoki.app
- Password: [secure password]

Notes for reviewer:
- This app manages medication reminders and adherence tracking.
- Sign in with Apple, Google, or continue anonymously.
- To test caregiver features, a second device with another account is needed.
- Travel Mode adjusts medication times based on timezone changes.
- In-app purchases remove ads (use Sandbox account to test).
- Medical disclaimer is displayed in the app description and settings.
```

### 7.3 Flutter 버전 리젝 확인

```bash
# 현재 Flutter 버전 확인
flutter --version

# GitHub에서 리젝 이슈 검색
# https://github.com/flutter/flutter/issues 에서
# "[버전 번호] rejection" 또는 "Guideline 2.5.1" 검색
```

---

## 8. 출시 후 계획

### 8.1 모니터링

| 항목 | 도구 | 주기 |
|------|------|------|
| 크래시 리포트 | Firebase Crashlytics | 매일 |
| 사용자 리뷰 | App Store Connect | 매일 |
| 다운로드 통계 | App Store Connect Analytics | 주간 |
| 광고 수익 | Google AdMob Dashboard | 주간 |
| 구독 현황 | App Store Connect Subscriptions | 주간 |

### 8.2 v1.1.0 업데이트 후보

| 기능 | 우선순위 | 설명 |
|------|---------|------|
| 홈 위젯 | HIGH | iOS Widget으로 빠른 복약 체크 |
| PDF 리포트 내보내기 | HIGH | 병원 방문 시 제출용 |
| 보호자 대시보드 고도화 | MEDIUM | 상세 알림 + 통계 |
| 다크 모드 | MEDIUM | 시스템 설정 연동 |
| AI 약물 상호작용 체크 | LOW | 실험적 기능 |

### 8.3 ASO (App Store Optimization)

- 출시 후 2주간 키워드 순위 모니터링
- 리뷰 요청 타이밍: 복약 7일 연속 달성 시 (긍정적 순간)
- A/B 테스트: 스크린샷 순서, 서브타이틀 변경
- 시즌별 키워드 조정 (인플루엔자 시즌, 화분증 시즌 등)

---

## 부록: 주요 파일 경로

| 파일 | 용도 |
|------|------|
| `ios/Runner.xcworkspace` | Xcode 워크스페이스 (이것을 열 것) |
| `ios/Runner/Runner.entitlements` | Sign in with Apple + Push 설정 |
| `ios/Runner/PrivacyInfo.xcprivacy` | Privacy manifest |
| `ios/Runner/Info.plist` | 권한 설명 + 앱 설정 |
| `pubspec.yaml` | 앱 버전 + 의존성 |
| `lib/l10n/app_en.arb` | 영어 로컬라이제이션 |
| `lib/l10n/app_ja.arb` | 일본어 로컬라이제이션 |
| `docs/APP_STORE_METADATA.md` | 마케팅 자료 (기존) |
| `docs/iOS_APP_STORE_DEPLOYMENT_GUIDE.md` | 빌드/배포 단계별 가이드 |
| `docs/product_requirements_document.md` | PRD (영어) |
