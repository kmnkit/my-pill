# Dosage Timing Redesign

## Overview

Schedule 설정에서 dosageTiming 프리셋이 시간 선택을 주도하도록 리디자인.
`dosageTimings`(처방 지시)와 `times`(알림 시간)의 모순을 구조적으로 제거한다.

## Understanding Summary

1. `dosageTimings`는 처방 기록(의사/약사 지시), `times`는 실제 알림 시간 — 1:1 매핑
2. dosageTiming 선택이 주도 -> 선택 개수 = 복용 횟수 = 시간 슬롯 수
3. DosageMultiplier 제거 (별도 횟수 선택 불필요)
4. 각 프리셋에 하드 제한 시간 범위 적용 (사용자 무신뢰 원칙)
5. 기본값은 고정, 나중에 설정에서 커스터마이징 가능
6. 모든 스케줄 타입(daily/specificDays/interval)에 동일 적용

### Non-goals

- 온보딩 생활 패턴 설정 (향후)
- 프리셋별 소프트 경고

### Assumptions

- 기본 시간값은 앱 내 상수로 관리 (설정 커스터마이징은 향후 별도 구현)
- interval 타입에서도 dosageTiming이 자연스럽게 작동할 것으로 가정 (피드백 후 재검토)
- 미출시 상태이므로 기존 데이터 마이그레이션 불필요

---

## Design

### 1. DosageTiming enum 강화

시간 메타데이터 추가:

| 필드 | 타입 | 설명 |
|------|------|------|
| defaultHour | int | 기본 시 |
| defaultMinute | int | 기본 분 |
| minHour | int | 허용 범위 시작 시 |
| maxHour | int | 허용 범위 종료 시 |

각 프리셋 정의:

| 프리셋 | 기본 시간 | 허용 범위 |
|--------|----------|----------|
| morning | 08:00 | 05:00 ~ 10:59 |
| noon | 12:00 | 11:00 ~ 14:59 |
| evening | 18:00 | 15:00 ~ 20:59 |
| bedtime | 22:00 | 21:00 ~ 01:59 |

범위 검증 메서드: `isTimeInRange(int hour, int minute)` — bedtime은 자정 wrap-around 처리.
defaultTimeOfDay getter: `TimeOfDay(hour: defaultHour, minute: defaultMinute)`.

### 2. DosageTimeSlot 모델 (신규)

Freezed 모델. DosageTiming과 사용자 지정 시간을 하나로 묶는다.

| 필드 | 타입 | 설명 |
|------|------|------|
| timing | DosageTiming | 프리셋 (morning/noon/evening/bedtime) |
| time | String | 실제 알림 시간 ("08:00" 형식) |

- 동일 timing 중복 불가
- 정렬 순서는 DosageTiming.index 기준
- 팩토리: `DosageTimeSlot.withDefault(DosageTiming)` -> 기본 시간으로 자동 생성

### 3. Schedule 모델 변경

제거:
- `timesPerDay` (int)
- `times` (List<String>)
- `dosageTimings` (List<DosageTiming>)

추가:
- `dosageSlots` (List<DosageTimeSlot>, default: [])

`int get timesPerDay => dosageSlots.length;` getter로 호환성 유지 가능.

### 4. UI 플로우

**새 플로우 (모든 타입 공통):**

```
빈도 선택 -> 타이밍 선택(DosageTimingSelector) -> 시간 조정(범위 제한 TimePicker)
```

변경 요약:

| 항목 | 변경 |
|------|------|
| DosageMultiplier | 제거 |
| DosageTimingSelector | 위치 상단으로 이동 (빈도 바로 뒤) |
| TimeSlotPicker | 제거, 새 위젯으로 대체 |
| 신규: DosageTimeAdjuster | 선택된 타이밍별 라벨 + 범위 제한 TimePicker |

타이밍 선택/해제 시 아래 시간 슬롯 자동 추가/제거.
각 슬롯은 해당 프리셋의 기본 시간으로 초기화.

---

## Affected Files

| 레이어 | 파일 | 변경 |
|--------|------|------|
| enum | dosage_timing.dart | 시간 메타데이터 + 범위 검증 메서드 |
| model | 신규 dosage_time_slot.dart | Freezed 모델 생성 |
| model | schedule.dart | 3필드 -> dosageSlots 교체 |
| service | reminder_service.dart 등 | 참조 변경 |
| provider | schedule_provider.dart, reminder_provider.dart | 참조 변경 |
| screen | schedule_screen.dart | 플로우 재구성 |
| widget | dosage_timing_selector.dart | DosageTimeSlot 생성 연동 |
| widget | 신규 dosage_time_adjuster.dart | 범위 제한 시간 조정 위젯 |
| widget | DosageMultiplier | 제거 |
| widget | TimeSlotPicker | 제거 |
| 기타 | medication_detail, timeline_card 등 | 참조 변경 |

## Verification

- `flutter analyze` 통과
- `build_runner build` 성공
- 각 프리셋의 범위 밖 시간 선택 불가 확인
- 타이밍 선택/해제 시 시간 슬롯 동적 추가/제거 확인
- 3가지 스케줄 타입 모두 정상 동작

---

## Decision Log

| # | 결정 | 대안 | 이유 |
|---|------|------|------|
| D1 | dosageTimings=처방 기록, times=알림 시간 | 동일 목적 | 역할이 다름 |
| D2 | 1:1 매핑 | 독립적 관계 | 처방 1건당 알림 1건 |
| D3 | dosageTiming 주도 | times 주도 / 수동 | 처방이 기준 |
| D4 | 고정 기본값 + 향후 커스터마이징 | 온보딩 설정 | YAGNI |
| D5 | 하드 제한 | 소프트 경고 / 무제한 | 사용자 무신뢰 원칙 |
| D6 | DosageMultiplier 제거 | 유지 | 타이밍 수 = 복용 횟수 |
| D7 | 모든 스케줄 타입 동일 적용 | daily만 | 통일 후 피드백 재검토 |
| D8 | DosageTimeSlot 모델 도입 | UI만 제어 / enum만 강화 | 데이터 레벨 정합성 |
| D9 | 마이그레이션 불필요 | 마이그레이션 구현 | 미출시 상태 |
