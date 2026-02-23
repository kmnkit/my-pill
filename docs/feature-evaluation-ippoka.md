# Feature Evaluation: 一包化 (Ippoka / Pre-packaged Medication Bundles)

> **Evaluator**: Stakeholder Agent
> **Date**: 2026-02-23
> **Status**: APPROVED (P1 — Phase 1 scope)
> **Verdict**: 전략적으로 강력히 추천. 일본 시장 핵심 차별화 기능.

---

## 1. Strategic Alignment Assessment

### Verdict: STRONGLY ALIGNED

Kusuridoki의 핵심 가치는 **"복잡한 복약 스케줄 관리의 간소화"** 이다. 一包化는 이 가치를 일본 시장 컨텍스트에서 가장 직접적으로 실현하는 기능이다.

**근거:**
- PRD Section 3.1에 명시된 "Medication Management"의 핵심은 Name, Dosage, Shape, Color, Schedule이다
- 一包化 사용자에게 Shape/Color는 **무의미** — 개별 약이 아닌 "시간대별 패킷"이 관리 단위
- 현재 UX는 개별 약 등록을 강제하므로, 一包化 사용자는 **5~10개 약을 각각 등록해야 하는 불필요한 마찰**을 겪는다
- 이 마찰이 해소되지 않으면 一包化 사용자는 앱을 **설치 직후 이탈**할 가능성이 높다

---

## 2. Target User Impact Analysis

### 一包化 사용자 세그먼트 규모

| 데이터 포인트 | 수치 | 출처 |
|--------------|------|------|
| 일본 65세 이상 인구 | 3,625만 명 (총인구 29.3%) | 총무성 통계국 2024 |
| 75세 이상 중 7종 이상 복용 | ~25% | 후생노동성 2023 |
| 75세 이상 중 5종 이상 복용 | ~40% | 후생노동성 데이터 |
| 一包化 대상 추정 | 5종+ 복용자 대부분 | 업계 관행 |

**핵심 인사이트**: 75세 이상 고령자의 약 40%가 5종 이상 약을 복용하며, 이들 중 상당수가 一包化 조제를 받고 있다. 2024년 조제보수 개정에서 外来服薬支援料2(一包化 가산)가 시설연계 가산으로 확대된 것은 정부 차원에서 一包化를 적극 추진하고 있음을 의미한다.

### 사용자 세그먼트 매핑

| 세그먼트 | 一包化 관련성 | 앱 니즈 |
|----------|-------------|---------|
| **고령 다제병용 환자** (PRIMARY) | 극히 높음 — 一包化 주 이용층 | 시간대별 패킷 단위 리마인더, 간호자 연동 |
| **고령자 보호자/가족** (SECONDARY) | 높음 — 부모의 一包化 패킷 관리 확인 | "아침 약 봉지 드셨나요?" 단위 확인 |
| **젊은 만성질환 환자** | 낮음 — 대부분 개별 약 관리 | 기존 pill-by-pill UX 충분 |

**결론**: 一包化 미지원 = Kusuridoki의 **PRIMARY 타겟 사용자 중 가장 약 의존도가 높은 층을 놓치는 것**.

---

## 3. Competitive Landscape

| 앱 | 一包化 대응 | 일본 시장 존재감 |
|----|-----------|----------------|
| お薬手帳 (EPARK 등) | 처방전 기반이라 간접 대응 | 높음 (약국 연동) |
| MyTherapy | 없음 (개별 약 등록만) | 중간 (글로벌) |
| MediSafe | 없음 | 낮음 (일본어 미지원) |
| Hanaサポート (東和薬品) | 약국 연동으로 부분 대응 | 낮음 (단일 제약사) |
| **Kusuridoki + 一包化** | **직접 대응 예정** | **차별화 포인트** |

**기회**: 현재 일본 시장에서 一包化를 UX 레벨에서 네이티브 지원하는 독립 앱이 사실상 **없다**. 대부분의 앱은 "개별 약 등록" 패러다임에 머물러 있다. 이것은 명확한 **시장 갭(market gap)** 이다.

---

## 4. Scope Recommendation

### 4.1 접근 방식: Per-Medication (약 단위)

제안된 "per-medication" 접근(약 등록 시 一包化 체크)을 **지지**하되, 다음과 같이 정제한다:

**IN SCOPE (Phase 1 — 현재 출시 범위):**

| 항목 | 설명 |
|------|------|
| `isIppoka` 플래그 | Medication 모델에 boolean 추가 |
| 등록 UX 분기 | 一包化 체크 시 PillShape/PillColor 선택 스킵 |
| 타임라인 표시 | 패킷 아이콘으로 차별 표시 (개별 약 모양 대신) |
| 그룹 표시 | 같은 시간대의 一包化 약들을 시각적으로 묶어 표시 |

**OUT OF SCOPE (Phase 1에서 제외):**

| 항목 | 이유 |
|------|------|
| "패킷 단위 일괄 등록" (하나의 패킷에 여러 약을 한번에 등록) | 모델 복잡도 급증. 현재 1약=1레코드 구조 유지가 안전 |
| 처방전 OCR/바코드 스캔 | 기술적 복잡도 + 의료기기 규제 리스크 |
| 약국 연동 API | 표준화된 API 부재 |
| 在庫管理 자동 연동 | 一包化는 약국이 재고 관리하므로 불필요 |

**DEFERRED (Phase 2 이후 검토):**

| 항목 | 조건 |
|------|------|
| "패킷 일괄 복용 완료" (한 시간대 一包化 약 전체를 한번에 '복용' 처리) | Phase 1 데이터로 니즈 검증 후 |
| 패킷 사진 등록 (봉지 사진) | 사용자 피드백 기반 |
| Per-timing-slot 모드 ("아침 봉지 전체"를 하나의 엔티티로) | 데이터 모델 재설계 필요, Phase 2+ |

### 4.2 왜 Per-Medication인가 (Per-Timing-Slot이 아닌)

| 기준 | Per-Medication | Per-Timing-Slot |
|------|---------------|----------------|
| 모델 변경 범위 | boolean 1개 추가 | 새 엔티티 + 관계 모델 필요 |
| 기존 코드 호환 | 완전 호환 | Schedule/Reminder 전면 수정 |
| 되돌림 비용 | 낮음 | 높음 |
| MVP 가치 검증 | 빠름 | 느림 |
| 사용자 가치 | 충분 (핵심 마찰 해소) | 더 나음 (이상적 UX) |

**판단**: Per-Medication으로 시작하고, Phase 1 사용 데이터를 보고 Per-Timing-Slot 업그레이드 여부를 결정한다. YAGNI 원칙 준수.

---

## 5. Business Goals Impact

| 기존 목표 | 一包化 영향 | 평가 |
|----------|-----------|------|
| 일본 시장 DAU 확보 | 고령 다제병용 환자 획득 가능 | ACCELERATES |
| 보호자 연동 활성화 | 一包化 사용자 = 보호자 연동 니즈 최고 | ACCELERATES |
| 앱 리텐션 | 핵심 타겟의 설치-이탈 방지 | ACCELERATES |
| 개발 일정 | 모델 변경 최소 (boolean 1개) | MINIMAL IMPACT |
| 수익화 (AdMob) | DAU 증가 = 광고 노출 증가 | ACCELERATES |

---

## 6. Priority Assignment

**Priority: P1 (Important — Phase 1 포함 권장)**

근거:
1. 일본 시장 핵심 타겟의 **가장 기본적인 워크플로우**에 해당
2. 구현 비용이 **매우 낮음** (모델 boolean + UI 분기)
3. 경쟁사 대비 **명확한 차별화** 요소
4. 미구현 시 **PRIMARY 사용자 이탈 리스크** 직결

P0로 올리지 않는 이유: 一包化 없이도 앱은 동작하며, 젊은 사용자층은 영향 없음. 하지만 **일본 시장 진입을 진지하게 고려한다면 Phase 1에 반드시 포함해야 한다**.

---

## 7. Monetization Impact

**없음 (무료 기능으로 제공)**

一包化는 프리미엄 게이트 뒤에 두면 안 된다. 이유:
- 주 사용자가 고령자/다제병용 환자 = 가장 취약한 의료 소비자
- 의약품 접근성 제한은 윤리적 리스크 + 앱스토어 리뷰 리스크
- 무료 제공으로 DAU를 확보하고, 광고 수익으로 회수하는 것이 전략적으로 올바름

---

## 8. Risk Assessment

| 리스크 | 심각도 | 완화 방안 |
|--------|--------|----------|
| 一包化 UX가 개별 약 UX와 혼재되어 혼란 | MEDIUM | 등록 초반에 명확한 분기 UI 제공 |
| Per-Medication 한계 (패킷 일괄 처리 불가) | LOW | Phase 2 DEFERRED로 명시, 사용자 피드백 수집 |
| 고령 사용자의 앱 사용 자체의 어려움 | MEDIUM | 보호자가 대리 설정하는 시나리오 지원 (기존 Caregiver 기능 활용) |
| 一包化 사용자의 在庫管理 불필요 | LOW | 一包化 약은 재고 추적 비활성화 옵션 제공 |

---

## 9. Implementation Constraints (비즈니스 관점)

다음 제약을 반드시 준수:

1. **Medication 모델 하위 호환성 유지**: 기존 데이터 마이그레이션 없이 `isIppoka: false` 기본값으로 처리
2. **기존 UX 영향 없음**: 一包化를 선택하지 않은 사용자는 현재와 동일한 경험
3. **l10n 완전 대응**: `ja` + `en` 양쪽 모두 자연스러운 표현 (일본어: 一包化, 영어: "Bundled packet" 또는 "Pre-packaged")
4. **접근성**: 고령자 사용을 고려한 충분한 터치 타겟 크기, 고대비 패킷 아이콘

---

## 10. Success Criteria

| 메트릭 | 목표 | 측정 방법 | 기한 |
|--------|------|----------|------|
| 一包化 등록 비율 | 전체 약 등록의 15%+ | Analytics 이벤트 | 출시 후 3개월 |
| 一包化 사용자 D7 리텐션 | 비一包化 사용자 대비 동등 이상 | Cohort 분석 | 출시 후 3개월 |
| 다제병용 사용자 (5종+) 등록 완료율 | 70%+ (등록 시작 대비) | Funnel 분석 | 출시 후 3개월 |

---

## Research Summary

### Sources Consulted
- [총무성 통계국 — 고령자 인구 통계 2024](https://www.stat.go.jp/data/topics/pdf/topics142.pdf): 65세 이상 3,625만 명, 29.3%
- [75세 이상 다제병용 통계](https://doctormate.co.jp/blog/kaigonews-131): 75세 이상의 ~25%가 7종+, ~40%가 5종+ 복용
- [2024년 조제보수 개정 — 一包化 가산](https://pharmacist.m3.com/column/chouzai_santei/6072): 外来服薬支援料2 시설연계 가산 신설
- [Global Medication Management App Market](https://www.globenewswire.com/news-release/2025/12/17/3206774/28124/en/Global-Medication-Side-Effect-Tracker-App-Market-to-Reach-2-45-Billion-by-2029.html): 2029년 $2.45B 시장 전망
- [MediSafe Alternatives](https://www.mytherapyapp.com/blog/medisafe-alternatives-free): 주요 경쟁앱 一包化 미대응 확인
- [一包化 해설 — Frontier Yui](https://frontier-yui.com/news/yogi/210/): 一包化 정의 및 현장 운용
- [アプリブ — 2026년 서약관리앱 추천](https://app-liv.jp/health/selfcares/0780/): 일본 서약관리앱 현황

### Key Market Insights
1. 일본 75세 이상 고령자의 40%가 5종 이상 약을 복용 — 一包化 대상 모수가 매우 큼
2. 2024년 조제보수 개정에서 一包化(外来服薬支援料2) 가산이 시설 연계로 확대 — 정부가 一包化를 적극 추진 중
3. 현존하는 주요 서약관리앱(MyTherapy, MediSafe, お薬手帳 계열) 중 一包化를 네이티브 UX로 지원하는 앱이 없음 — 명확한 시장 갭
4. 글로벌 약물관리앱 시장은 2029년 $2.45B 규모로 성장 전망, 고령자 + 다제병용이 핵심 성장 동인

### Competitive Landscape

| 경쟁사 | 포지셔닝 | 강점 | 약점 |
|--------|---------|------|------|
| お薬手帳 (EPARK) | 약국 연동 처방전 관리 | 약국 생태계 통합 | 독립 서약관리 약함, 一包化 UX 없음 |
| MyTherapy | 글로벌 만성질환 관리 | 포괄적 건강 추적 | 일본 로컬라이즈 약함, 一包化 없음 |
| MediSafe | 글로벌 약 리마인더 | 10M+ 사용자, AI 인사이트 | 일본어 미지원, 一包化 없음 |
| Hanaサポート | 東和薬品 전용 | 약국 직접 연동 | 단일 제약사 종속, 범용성 없음 |

---

## Final Recommendation

**APPROVE. Phase 1 범위에 포함할 것.**

一包化 지원은 Kusuridoki가 일본 시장에서 "또 하나의 글로벌 약 리마인더 앱"이 아닌, **일본 의료 현실을 이해하는 로컬 앱**으로 포지셔닝하기 위한 핵심 차별화 요소이다.

구현 비용(모델 boolean + UI 분기)은 낮고, 비즈니스 임팩트(핵심 타겟 획득 + 리텐션)는 높다. ROI가 매우 명확한 기능이다.

다만 Per-Timing-Slot(패킷 단위 엔티티) 접근은 Phase 1에서 명확히 제외한다. Per-Medication boolean으로 시작하여 시장 반응을 검증한 후 확장 여부를 결정한다.
