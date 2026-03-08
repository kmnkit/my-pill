# Screenshot Integration Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** `screenshot` 패키지로 App Store + ProductHunt 공용 스크린샷 10장(ja 5장 + en 5장)을 자동 생성한다.

**Architecture:** `lib/core/screenshot/` 아래 오버레이 위젯과 갤러리 화면을 만든다. `main_screenshot.dart` 를 갤러리 진입점으로 교체하고, 버튼 탭 한 번에 ja/en 각 5장을 기기 Documents에 저장한다.

**Tech Stack:** `screenshot ^3.0.0`, `path_provider ^2.1.5` (이미 pubspec에 있음), Riverpod ProviderScope override (caregiver mock)

---

## Task 1: screenshots/ 디렉토리 gitignore 추가

**Files:**
- Modify: `.gitignore`

**Step 1:** `.gitignore` 에 `screenshots/` 추가

**Step 2:** 확인

```bash
cat .gitignore | grep screenshots
```

Expected: `screenshots/` 출력

**Step 3: Commit**

```bash
git add .gitignore
git commit -m "chore: ignore generated screenshots/ directory"
```

---

## Task 2: ScreenshotCaptionOverlay 위젯 + 테스트

**Files:**
- Create: `lib/core/screenshot/screenshot_caption_overlay.dart`
- Create: `test/core/screenshot/screenshot_caption_overlay_test.dart`

**Step 1: 테스트 먼저 작성**

`test/core/screenshot/screenshot_caption_overlay_test.dart` 에:
- 캡션 문자열이 렌더링되는지 확인하는 widget test
- child 위젯이 렌더링되는지 확인하는 widget test

**Step 2: 테스트 실패 확인**

```bash
flutter test test/core/screenshot/screenshot_caption_overlay_test.dart
```

Expected: `Target file not found` 또는 import 오류

**Step 3: 위젯 구현**

`lib/core/screenshot/screenshot_caption_overlay.dart`:
- `child` (Widget), `caption` (String) 파라미터
- `Stack`: child + 하단 LinearGradient 박스 + 흰색 캡션 텍스트
- 그라디언트: 투명 → 반투명 다크 (`Colors.black54`)
- 텍스트: `headlineMedium`, white, center, padding 16

**Step 4: 테스트 통과 확인**

```bash
flutter test test/core/screenshot/screenshot_caption_overlay_test.dart
```

Expected: PASS

**Step 5: Commit**

```bash
git add lib/core/screenshot/screenshot_caption_overlay.dart \
        test/core/screenshot/screenshot_caption_overlay_test.dart
git commit -m "feat: add ScreenshotCaptionOverlay widget"
```

---

## Task 3: CaregiverDashboard 스크린샷용 mock override

**Files:**
- Create: `lib/core/screenshot/screenshot_caregiver_override.dart`
- Create: `test/core/screenshot/screenshot_caregiver_override_test.dart`

**Step 1: 테스트 먼저 작성**

`caregiverPatientsProvider`를 override했을 때 더미 환자 1명(`patientId: 'demo-patient'`, `patientName: 'さくら'`)이 반환되는지 확인하는 provider 테스트

**Step 2: 테스트 실패 확인**

```bash
flutter test test/core/screenshot/screenshot_caregiver_override_test.dart
```

**Step 3: override 구현**

`lib/core/screenshot/screenshot_caregiver_override.dart`:
- `caregiverPatientsOverride` 상수: `caregiverPatientsProvider`를 `AsyncData`로 override
- 더미 값: `patientId: 'demo-patient'`, `patientName: 'さくら'`, `linkedAt: null`
- 반환 타입: `List<({String patientId, String patientName, DateTime? linkedAt})>`

**Step 4: 테스트 통과 확인**

```bash
flutter test test/core/screenshot/screenshot_caregiver_override_test.dart
```

**Step 5: Commit**

```bash
git add lib/core/screenshot/screenshot_caregiver_override.dart \
        test/core/screenshot/screenshot_caregiver_override_test.dart
git commit -m "feat: add caregiver mock override for screenshots"
```

---

## Task 4: ScreenshotGalleryScreen 구현 + 테스트

**Files:**
- Create: `lib/core/screenshot/screenshot_gallery_screen.dart`
- Create: `test/core/screenshot/screenshot_gallery_screen_test.dart`

**Step 1: 테스트 먼저 작성**

`test/core/screenshot/screenshot_gallery_screen_test.dart`:
- "Capture All" 버튼이 렌더링되는지 확인
- 5개 화면 식별자가 모두 포함된 목록이 있는지 확인 (직접 렌더링하지 않고 화면 설정 리스트 단위 테스트)

**Step 2: 테스트 실패 확인**

```bash
flutter test test/core/screenshot/screenshot_gallery_screen_test.dart
```

**Step 3: 갤러리 화면 구현**

`lib/core/screenshot/screenshot_gallery_screen.dart`:

화면 설정 리스트 (5항목, ja/en 각 캡션 포함):
| index | widgetBuilder | filenameBase | jaCaption | enCaption |
|-------|--------------|--------------|-----------|-----------|
| 0 | HomeScreen | 01_home | 今日のお薬、ひと目でわかる | Your daily meds, at a glance |
| 1 | MedicationsListScreen | 02_medications_list | すべての薬を一か所で管理 | All your medications, in one place |
| 2 | WeeklySummaryScreen | 03_weekly_summary | 服薬の習慣が見えてくる | Watch your habits come to life |
| 3 | CaregiverDashboardScreen (+ caregiverPatientsOverride) | 04_caregiver | 家族の服薬を見守る | Keep watch over a loved one |
| 4 | TravelModeScreen | 05_travel_mode | 旅先でも飲み忘れゼロ | Never miss a dose, even abroad |

로직:
- `ScreenshotController` 1개 재사용
- "Capture All" 버튼 탭 시: ja → en 순서로 각 화면을 `ScreenshotController.captureFromWidget()` 으로 캡처
- 각 화면을 `Localizations.override(locale: Locale(langCode))` 로 감쌈
- `path_provider`의 `getApplicationDocumentsDirectory()` + `screenshots/{lang}/` 서브디렉토리에 PNG 저장
- 완료 후 SnackBar: "10 screenshots saved to Documents/screenshots/"

**Step 4: 테스트 통과 확인**

```bash
flutter test test/core/screenshot/screenshot_gallery_screen_test.dart
```

**Step 5: Commit**

```bash
git add lib/core/screenshot/screenshot_gallery_screen.dart \
        test/core/screenshot/screenshot_gallery_screen_test.dart
git commit -m "feat: add ScreenshotGalleryScreen"
```

---

## Task 5: main_screenshot.dart 갤러리 진입점으로 교체

**Files:**
- Modify: `lib/main_screenshot.dart`

**Step 1: 현재 코드 확인**

```bash
cat lib/main_screenshot.dart
```

현재: 시드 후 `KusuridokiApp()` 실행

**Step 2: 변경**

시드 후 `KusuridokiApp` 대신 `ScreenshotGalleryScreen`을 루트로 하는 단순 `MaterialApp` 실행:
- `ProviderScope` 유지 (시드 데이터 providers 접근 필요)
- `supportedLocales`, `localizationsDelegates` 설정 (ja/en 전환을 위해 필수)
- `home: ScreenshotGalleryScreen()`

**Step 3: 정적 분석**

```bash
flutter analyze lib/main_screenshot.dart
```

Expected: 0 errors

**Step 4: Commit**

```bash
git add lib/main_screenshot.dart
git commit -m "feat: route main_screenshot to ScreenshotGalleryScreen"
```

---

## Task 6: 실제 스크린샷 캡처 실행

**Step 1: 시뮬레이터에서 실행**

```bash
flutter run -t lib/main_screenshot.dart
```

iPhone 15 Pro (6.7") 시뮬레이터 권장

**Step 2: "Capture All" 버튼 탭**

앱이 갤러리 화면으로 시작되면 "Capture All" 버튼 탭.
완료 SnackBar 확인.

**Step 3: 파일 확인**

```bash
# 시뮬레이터 Documents 경로 찾기
find ~/Library/Developer/CoreSimulator/Devices -name "01_home.png" 2>/dev/null | head -5
```

Expected: `screenshots/ja/01_home.png` 등 10개 파일

**Step 4: 파일 열어서 육안 확인**

```bash
open "$(find ~/Library/Developer/CoreSimulator/Devices -name "01_home.png" 2>/dev/null | head -1)"
```

캡션 오버레이, 시드 데이터, 광고 없음 확인

**Step 5: 최종 commit**

```bash
git add docs/plans/
git commit -m "docs: add screenshot integration plan"
```

---

## 완료 기준

- [ ] `screenshots/ja/` 5개 PNG, `screenshots/en/` 5개 PNG 생성됨
- [ ] 각 이미지에 캡션 오버레이 포함
- [ ] 광고 배너 없음
- [ ] CaregiverDashboard에 더미 환자 1명 표시
- [ ] `flutter analyze` 0 errors
- [ ] 모든 신규 테스트 PASS
