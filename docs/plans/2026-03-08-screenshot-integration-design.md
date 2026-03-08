# Screenshot Integration Design

**Date:** 2026-03-08
**Scope:** App Store + ProductHunt 스크린샷 자동 생성
**Package:** `screenshot` (Flutter)

---

## Goal

`screenshot` 패키지를 사용해 App Store(ja/en)와 ProductHunt 공용으로 사용할 스크린샷 5장을 자동 생성한다. 각 화면에 캡션 오버레이 포함.

---

## Screen Selection (Option B — Story-driven)

| # | Screen | ja 캡션 | en 캡션 |
|---|--------|---------|---------|
| 1 | HomeScreen | 今日のお薬、ひと目でわかる | Your daily meds, at a glance |
| 2 | MedicationsListScreen | すべての薬を一か所で管理 | All your medications, in one place |
| 3 | WeeklySummaryScreen | 服薬の習慣が見えてくる | Watch your habits come to life |
| 4 | CaregiverDashboardScreen | 家族の服薬を見守る | Keep watch over a loved one |
| 5 | TravelModeScreen | 旅先でも飲み忘れゼロ | Never miss a dose, even abroad |

---

## Output Structure

```
screenshots/
├── ja/
│   ├── 01_home.png
│   ├── 02_medications_list.png
│   ├── 03_weekly_summary.png
│   ├── 04_caregiver.png
│   └── 05_travel_mode.png
└── en/
    ├── 01_home.png
    ├── 02_medications_list.png
    ├── 03_weekly_summary.png
    ├── 04_caregiver.png
    └── 05_travel_mode.png
```

---

## Technical Design

### Entry Point
기존 `lib/main_screenshot.dart` 재사용. `ScreenshotDataSeeder`가 시드 데이터를 주입한 후 앱 실행.

### Screenshot Flow
- 별도 `ScreenshotGalleryScreen` 위젯을 만들어 5개 화면을 순서대로 렌더링
- 각 화면을 `screenshot` 패키지의 `ScreenshotController`로 PNG 캡처
- `path_provider`로 기기 Documents 디렉토리에 `screenshots/ja/`, `screenshots/en/` 저장

### Caption Overlay
- 각 화면을 `Stack`으로 감싸고 하단에 오버레이 박스 추가
- 오버레이: 반투명 다크 그라디언트 + 흰색 캡션 텍스트 (2줄)
- `locale`을 `ja` / `en`으로 각각 전환해 2회 캡처

### CaregiverDashboard Mock
- `caregiverPatientsProvider`를 ProviderScope override로 더미 환자 1명 주입
- Firebase 연결 없이 렌더링 가능하도록 처리

---

## Constraints

- 광고 배너는 이미 `AdService._hideAdsForScreenshots = true`로 숨겨짐
- 시드 데이터: 5개 약, 87% 복약률, 오늘 아침 복약 완료 + 오후 pending 상태

---

## Out of Scope

- 디바이스 프레임(iPhone 목업) 합성 — 별도 후처리로 진행
- iPad 사이즈 대응
- 자동 CI 파이프라인 통합
