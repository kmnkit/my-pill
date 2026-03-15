# Privacy Policy Sentry→Crashlytics 수정 계획

> **For agentic workers:** REQUIRED: Use superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Privacy Policy의 Sentry 언급 12곳(EN 6 + JA 6)을 Firebase Crashlytics 기준으로 수정하여 실제 앱 동작과 일치시킴

**Architecture:** `site/privacy-policy/index.html` 단일 파일 수정. 기존 섹션 구조 유지. Sentry 고유 기능(Session Replay, scrubber, performance tracing)은 Crashlytics에 해당 없으므로 제거.

**Tech Stack:** Static HTML

---

## 배경

앱이 Sentry → Firebase Crashlytics로 전환 완료(커밋 `b0da16d`)되었으나, Privacy Policy는 여전히 Sentry를 참조. App Store 심사에서 privacy policy와 실제 동작 불일치로 리젝 가능.

**기존 계획 `2026-03-13-user-disclosure-fixes.md` Task 2 (Sentry Session Replay 범위 정정)는 본 계획으로 대체됨.**

## Crashlytics vs Sentry — 고지 영향 비교

| 항목 | Sentry (현재 고지) | Crashlytics (실제) | 고지 변경 |
|------|-------------------|-------------------|----------|
| 제공사 | Functional Software, Inc. | Google LLC (Firebase) | 교체 |
| Session Replay | 10% all + 100% error | **없음** | 삭제 |
| Screenshot 첨부 | 있음 | **없음** | 삭제 |
| PHI Scrubber | 있음 (약 이름/용량 제거) | **불필요** (스택트레이스만 수집) | 삭제 → 간단히 "수집 안 함" 명시 |
| Performance tracing | 20% 샘플링 | **없음** (Firebase Performance 미사용) | 삭제 |
| 서버 위치 | 미국 특정 | Google Cloud (글로벌) | 교체 |
| 보존 기간 | 90일 | 90일 | 유지 |
| User ID | Firebase UID | Firebase UID (`setUserIdentifier`) | 유지 |
| 수집 데이터 | stack trace, device info, session replay, performance | stack trace, device info | 축소 |

## 변경 맵

| 섹션 | 줄 (EN / JA) | 변경 내용 |
|------|-------------|----------|
| Section 4 — Data Sharing | 111 / 230 | Sentry 항목 → Crashlytics로 교체 |
| Section 5 — Third-Party | 121, 124 / 240, 243 | Sentry 독립 항목 삭제, Firebase 항목에 Crashlytics 병합, Sentry Privacy Policy 링크 삭제 |
| Section 6 — Crash Reporting | 127-136 / 246-255 | 전체 재작성 (제목 유지, 내용 Crashlytics 기준) |
| Section 7 — Data Retention | 142 / 261 | "Sentry" → "Firebase Crashlytics" |
| 날짜 | 72 / 191 | Last updated 날짜 갱신 |

---

## Task 1: Section 4 — Data Sharing (EN + JA)

**파일:** `site/privacy-policy/index.html`

**EN (줄 111):** Sentry 항목을 Crashlytics로 교체
- 현재: "Sentry: Crash reports and performance data (health information is automatically removed before transmission — see Section 6)"
- 변경: Crashlytics가 수집하는 실제 데이터(crash data, device info)만 명시, Section 6 참조 유지

**JA (줄 230):** 동일 변경의 일본어 버전

- [ ] EN Section 4 Sentry 항목 교체
- [ ] JA Section 4 Sentry 항목 교체
- [ ] 검증: 파일 내 Section 4 범위에서 "Sentry" 0건

---

## Task 2: Section 5 — Third-Party Services (EN + JA)

**파일:** `site/privacy-policy/index.html`

**EN (줄 118-124):**
- Firebase 항목에 Crashlytics 추가: "Firebase Authentication, Firestore, Cloud Functions, Cloud Messaging, **Crashlytics** (Google)"
- Sentry 독립 항목 (`<li>Sentry (crash reporting...)</li>`) 삭제
- Privacy Policy 링크에서 Sentry 링크 삭제 (Google/Apple/RevenueCat만 유지)

**JA (줄 237-243):** 동일 변경의 일본어 버전

- [ ] EN Section 5 Firebase 항목에 Crashlytics 추가
- [ ] EN Section 5 Sentry 독립 항목 삭제
- [ ] EN Sentry Privacy Policy 링크 삭제
- [ ] JA 동일 3건 적용
- [ ] 검증: 파일 내 Section 5 범위에서 "Sentry" / "sentry" 0건

---

## Task 3: Section 6 — Crash Reporting 전체 재작성 (EN + JA)

**파일:** `site/privacy-policy/index.html`

가장 큰 변경. Sentry 전용 섹션을 Crashlytics 기준으로 재작성.

**제목:** "Crash Reporting & Performance Monitoring" → "Crash Reporting" (Performance Monitoring 미사용)

**EN (줄 127-136) 재작성 구조:**
1. **도입:** "We use Firebase Crashlytics (provided by Google LLC)..." — 목적: app stability monitoring
2. **수집 데이터 목록 (3항목):**
   - Crash reports: stack traces, error messages, app state at time of error
   - Device information: device model, OS version, app version, locale
   - User identifier: anonymous Firebase user ID only (no name or email)
3. **수집하지 않는 데이터:** Crashlytics는 스크린샷, 화면 녹화, UI 콘텐츠를 캡처하지 않음. 약 이름, 용량, 사진 등 건강 관련 정보는 크래시 리포트에 포함되지 않음
4. **처리 위치:** Google Cloud infrastructure
5. **옵트아웃:** 기존과 동일 (account deletion + uninstall)

**삭제 항목:**
- Session Replay 전체 (Crashlytics에 없음)
- Performance data / transaction traces (Firebase Performance 미사용)
- Scrubber 설명 ("자동 제거" → "애초에 수집 안 함"으로 단순화)
- "Functional Software, Inc." 참조
- "United States" 서버 위치 특정

**JA (줄 246-255):** 동일 구조의 일본어 버전

- [ ] EN Section 6 전체 재작성
- [ ] JA Section 6 전체 재작성
- [ ] 검증: "Sentry" 0건, "Session Replay" 0건, "セッションリプレイ" 0건, "Functional Software" 0건

---

## Task 4: Section 7 — Data Retention (EN + JA)

**파일:** `site/privacy-policy/index.html`

**EN (줄 142):**
- 현재: "Retained by Sentry for 90 days, then automatically deleted."
- 변경: "Retained by Firebase Crashlytics for 90 days, then automatically deleted."

**JA (줄 261):**
- 현재: "Sentryに90日間保持された後、自動的に削除されます。"
- 변경: "Firebase Crashlyticsに90日間保持された後、自動的に削除されます。"

- [ ] EN Section 7 수정
- [ ] JA Section 7 수정
- [ ] 검증: Section 7 범위에서 "Sentry" 0건

---

## Task 5: Last Updated 날짜 갱신

**파일:** `site/privacy-policy/index.html`

- EN (줄 72): "Last updated: March 13, 2026" → "Last updated: March 14, 2026"
- JA (줄 191): "最終更新日: 2026年3月13日" → "最終更新日: 2026年3月14日"

- [ ] EN 날짜 갱신
- [ ] JA 날짜 갱신

---

## 최종 검증

- [ ] 파일 전체에서 `Sentry` 검색 → 0건
- [ ] 파일 전체에서 `sentry` 검색 → 0건
- [ ] 파일 전체에서 `Session Replay` / `セッションリプレイ` 검색 → 0건
- [ ] 파일 전체에서 `Functional Software` 검색 → 0건
- [ ] EN/JA 내용 일관성 확인 (동일 항목이 양쪽에 존재)
- [ ] 브라우저에서 EN/JA 전환 정상 동작

## 커밋

`문서: Privacy Policy Sentry→Crashlytics 수정`

## Devil's Advocate Review

- **도전한 가정:** "Crashlytics 보존 기간 90일" — Firebase Console 기본값 기준. 커스텀 설정은 확인 불요 (기본값 사용 중).
- **검토한 대안:** Section 6을 완전 삭제하고 Section 5 Firebase 항목에 통합 → 기각. 구조 변경이 크고, 크래시 리포팅 고지를 별도 섹션으로 유지하는 것이 투명성 면에서 유리.
- **식별된 리스크:** EN/JA 불일치 가능 → 완화: 각 Task에서 EN/JA 동시 수정 + 최종 검증에서 일관성 체크.
- **결론:** 5 Task, 1 커밋. 단일 파일 텍스트 교체로 privacy policy-코드 불일치 해소.
