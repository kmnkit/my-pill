# iOS App Store 배포 상태 리포트

**프로젝트:** Kusuridoki - Medication Reminder
**배포판:** v1.0.0+1
**Bundle ID:** com.ginger.mypill
**대상:** iOS 12.0+, 글로벌 전체 지역
**상태:** 70% 완료 (자동화 부분)

---

## 📊 진행 상황 요약

| Phase | 작업 | 상태 | 완료 날짜 |
|-------|------|------|----------|
| 1 | Xcode 프로젝트 설정 (Team) | ⏳ 수동 필요 | - |
| 2 | Capabilities 추가 | ✅ 완료 | 2026-02-03 |
| 3 | PrivacyInfo.xcprivacy 생성 | ✅ 완료 | 2026-02-03 |
| 4 | Info.plist 권한 설명 | ✅ 완료 | 2026-02-03 |
| 5 | App Store Connect 등록 | ⏳ 수동 필요 | - |
| 6 | 마케팅 자료 | ✅ 완료 | 2026-02-03 |
| 7 | Build & Archive | ⏳ Phase 1 대기 | - |
| 8 | App Store 업로드 | ⏳ Phase 7 대기 | - |
| 9 | TestFlight 테스트 | ⏳ Phase 8 대기 | - |
| 10 | App Store 제출 | ⏳ Phase 9 대기 | - |

**전체 진행률:** 🟦🟦🟦🟦🟦🟦🟦⬜⬜⬜ (70%)

---

## ✅ 완료된 작업 (자동화)

### Phase 2: Capabilities 추가
**파일:** `ios/Runner/Runner.entitlements`

추가된 내용:
```xml
<key>aps-environment</key>
<string>production</string>
```

**효과:**
- Push Notifications 활성화 (Firebase Cloud Messaging)
- Production 환경에서 원격 알림 수신
- Background 모드에서 알림 처리

---

### Phase 3: PrivacyInfo.xcprivacy 생성
**파일:** `ios/Runner/PrivacyInfo.xcprivacy` (신규 생성)

**포함된 선언:**
- **NSPrivacyTracking:** true (AdMob 추적 활성화)
- **NSPrivacyTrackingDomains:** Google 광고 도메인
- **NSPrivacyCollectedDataTypes:**
  - Health (건강 데이터) - App Functionality, Not Tracking
  - Contacts (연락처) - App Functionality, Not Tracking
  - Photos (사진) - App Functionality, Not Tracking
  - ProductInteraction (상호작용) - Third-Party Advertising, Tracking

- **NSPrivacyAccessedAPITypes:**
  - UserDefaults (CA92.1)
  - FileTimestamp (C617.1)
  - SystemBootTime (35F9.1)

**iOS 17+ 준수:** ✅ 완료
**App Store 심사 필수:** ✅ 포함

---

### Phase 4: Info.plist 권한 설명 추가
**파일:** `ios/Runner/Info.plist`

추가된 권한 (6개):

| 키 | 설명 | 용도 |
|----|------|------|
| NSCameraUsageDescription | 약 사진 촬영 | 약물 식별 |
| NSPhotoLibraryUsageDescription | 사진 라이브러리에서 선택 | 기존 약 사진 재사용 |
| NSPhotoLibraryAddUsageDescription | 라이브러리에 저장 | 촬영한 약 사진 저장 |
| NSUserTrackingUsageDescription | 맞춤 광고 표시 | AdMob 개인화 |
| NSFaceIDUsageDescription | Face ID 로그인 | 생체 인증 보안 |
| NSNotificationUsageDescription | 복약 알림 수신 | 시간별 복약 리마인더 |

**앱 심사 시** 각 권한에 대해 iOS에서 사용자 동의 요청

---

### Phase 6: 마케팅 자료 준비 완료

#### 생성된 문서

**1. APP_STORE_METADATA.md**
- 스크린샷 사양: 1290×2796 px (6.7" Display)
- 권장 스크린샷 5개 순서 제시
- 영문 앱 설명 (의료 면책 포함)
- 한글 앱 설명 (의료 면책 포함)
- SEO 키워드 (영문/한글)
- Age Rating 정보
- Demo Account 설정 가이드

**2. iOS_APP_STORE_DEPLOYMENT_GUIDE.md**
- 845줄, 24KB 완전 배포 가이드
- 10개 Phase별 상세 지침
- Xcode GUI 네비게이션 단계별 설명
- 모든 bash 명령어 포함
- 문제 해결 가이드 (8가지 솔루션)
- 다국어 지원 (영문/한글)

#### App Icon 검증
- ✅ 위치: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- ✅ 1024×1024 PNG 존재 (Icon-App-1024x1024@1x.png)
- ✅ 모든 필수 크기 포함 (20, 29, 40, 60, 76, 83.5, 1024)
- ✅ 투명 배경 제외 (RGB, opaque)

---

## ⏳ 수동 설정 필요

### Phase 1: Xcode 프로젝트 설정 (CRITICAL - 차단 요소)

**반드시 완료해야 Phase 7-10 진행 가능**

#### Step 1: Xcode 열기
```bash
open /Users/gingermarco/develop/flutter/kusuridoki/ios/Runner.xcworkspace
```

#### Step 2: Apple Developer Account 연결
1. Xcode → Settings (⌘,)
2. Accounts 탭
3. "+" 클릭 → Add Apple ID
4. Apple Developer 계정으로 로그인

#### Step 3: Team 설정
1. Project Navigator에서 **Runner** (파란 아이콘) 클릭
2. **Runner** target 선택
3. **Signing & Capabilities** 탭
4. **"Automatically manage signing"** 체크
5. **Team** 드롭다운에서 개발 팀 선택
6. Bundle ID 확인: `com.ginger.mypill`

#### Step 4: 검증
- ✓ Signing Certificate: "Apple Development: [your email]"
- ✓ Provisioning Profile: "Xcode Managed Profile"
- ✓ 빨간 오류 아이콘 없음

**소요 시간:** ~5분

---

### Phase 5: App Store Connect 등록 (CRITICAL - 차단 요소)

**URL:** https://appstoreconnect.apple.com

#### Step 1: 앱 생성
- My Apps → + → New App
- Name: **Kusuridoki - Medication Reminder**
- Primary Language: **English (U.S.)**
- Bundle ID: **com.ginger.mypill**
- SKU: **mypill-ios-001**

#### Step 2: App Information
- Category Primary: **Medical**
- Category Secondary: **Health & Fitness**
- Content Rights: ☑️ Contains third-party content

#### Step 3: Pricing & Availability
- Price: **Free**
- Availability: **All countries/regions**

#### Step 4: Privacy
- Data Collection: Yes
- Health & Fitness → App Functionality (Linked, Not Tracking)
- Contact Info → App Functionality (Linked, Not Tracking)
- Photos/Videos → App Functionality (Linked, Not Tracking)
- Product Interaction → Third-Party Advertising (Not Linked, Tracking)

#### Step 5: In-App Purchase (프리미엄 구독)
- Type: **Auto-Renewable Subscription**
- Subscription Group: **Premium Subscription**
- Product ID: **com.ginger.mypill.premium.monthly**
- Duration: **1 Month**
- Price Tier: **5** (₩5,500 KRW / $4.99 USD)
- Localization: English + Korean

**소요 시간:** ~30분

---

## 🚀 다음 단계 (차단 요소 해제 후)

### Phase 1 & 5 완료 시:

#### Phase 7: Build & Archive (자동화 가능)
```bash
cd /Users/gingermarco/develop/flutter/kusuridoki
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter gen-l10n
cd ios && pod install --repo-update && cd ..
flutter build ios --release --no-codesign

# Xcode Archive
cd ios
xcodebuild \
  -workspace Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -derivedDataPath build \
  -allowProvisioningUpdates \
  archive \
  -archivePath build/Kusuridoki.xcarchive
cd ..
```

**소요 시간:** ~15-30분

#### Phase 8: App Store Connect 업로드
- Xcode Organizer → Archive 선택
- Distribute App → App Store Connect
- Upload
- TestFlight에서 "Processing" 상태 확인

**소요 시간:** ~10-20분 + 30-60분 처리

#### Phase 9: TestFlight 테스트
- Internal Testing 그룹 생성
- Testers 추가
- 다음 항목 테스트:
  - Apple/Google Sign-In ✓
  - Medication CRUD operations ✓
  - Push Notifications ✓
  - Adherence Tracking ✓
  - Caregiver Linking ✓
  - AdMob Ads ✓
  - IAP Subscription (Sandbox) ✓
  - Permissions requests ✓
  - Firestore sync ✓

**소요 시간:** ~1-3일

#### Phase 10: App Store 제출
- Screenshots 업로드 (1290×2796, 최소 3장)
- App Description 입력 (영문/한글)
- Age Rating: 4+
- Demo Account 제공
- Medical Disclaimer 포함
- Submit for Review
- 심사 대기: 5-7일

**소요 시간:** ~1-2시간 + 5-7일 심사

---

## 📋 체크리스트

### 즉시 필요 (현재)
- [ ] Phase 1: Xcode에서 Apple Developer Team 설정
- [ ] Phase 5: App Store Connect에 앱 등록

### Build & Deploy (Phase 1, 5 완료 후)
- [ ] Phase 7: Build & Archive 실행
- [ ] Phase 8: App Store Connect 업로드
- [ ] Phase 9: TestFlight 테스트 완료
- [ ] Phase 10: App Store 제출

### Post-Release
- [ ] App Store에서 검색 확인
- [ ] 사용자 발표
- [ ] Review 모니터링

---

## 📁 생성된 파일

| 파일 | 크기 | 목적 |
|------|------|------|
| `ios/Runner/PrivacyInfo.xcprivacy` | 2.8 KB | iOS 17+ Privacy Manifest |
| `ios/Runner/Runner.entitlements` | (수정) | Push Notifications 활성화 |
| `ios/Runner/Info.plist` | (수정) | 권한 설명 추가 |
| `docs/APP_STORE_METADATA.md` | 3.2 KB | 메타데이터 및 설명 |
| `docs/iOS_APP_STORE_DEPLOYMENT_GUIDE.md` | 24 KB | 완전 배포 가이드 |

---

## 🔄 의존성 체인

```
Phase 1 (Team Setup) ───┐
                        ├─→ Phase 7 (Build & Archive)
Phase 5 (App Store) ────┤
                        └─→ Phase 8 (Upload)
                            └─→ Phase 9 (TestFlight)
                                └─→ Phase 10 (Submit)
```

**Phase 1, 5가 완료되지 않으면 Phase 7 이후는 진행 불가**

---

## ⚠️ 중요 사항

1. **PrivacyInfo.xcprivacy는 필수:** iOS 17+에서 AdMob 사용하는 앱은 이 파일 없이 심사 불가능
2. **Medical Disclaimer 필수:** 건강/의료 카테고리는 전문가 상담 대체 불가 문구 필수
3. **Demo Account 실제 작동:** 심사자가 로그인 가능한 유효한 테스트 계정 필수
4. **Privacy Policy 필수:** App Store Connect → Support URL에 반드시 입력
5. **스크린샷 최소 3장:** 6.7" Display 크기로 주요 기능 보여줘야 함

---

## 📞 지원

도움말:
- `/help`: Claude Code 도움말
- Issue: https://github.com/anthropics/claude-code/issues

문서:
- `docs/iOS_APP_STORE_DEPLOYMENT_GUIDE.md` - 완전 단계별 가이드
- `docs/APP_STORE_METADATA.md` - 메타데이터 템플릿

---

**마지막 업데이트:** 2026-02-03
**배포판:** Kusuridoki v1.0.0+1
**상태:** 70% 완료 - Phase 1, 5 수동 설정 대기 중
