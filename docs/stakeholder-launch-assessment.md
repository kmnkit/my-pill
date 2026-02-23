# Stakeholder 출시 준비 평가 — Kusuridoki (くすりどき)

> **평가일**: 2026-02-23
> **평가자**: Stakeholder (CPO 역할)
> **평가 기준**: 보안 리뷰 결과 + 6단계 개선 완료 후 재평가
> **이전 PO 점수**: 4.5/10 (NO-GO)

---

## 1. 종합 판정

### NO-GO — 3.5 / 10

6단계 개선 작업(명칭 정리, 버전 고정, 프라이버시 링크, 인터벌 버그, 테스트, 진행 문서)은 모두 완료되었고 가치 있는 진전이다. 그러나 보안 리뷰에서 드러난 **3건의 CRITICAL 이슈가 미수정 상태**이며, 이 중 2건은 App Store 제출 즉시 리젝 사유이고 1건은 일본 APPI 법 위반이다. 출시는 불가하다.

| 평가 영역 | 점수 | 근거 |
|-----------|------|------|
| 코드 품질 / 테스트 | 6/10 | 75 tests pass, 0 analyze 이슈. 단, 플랫폼 서비스(Notification, IAP) 테스트 미비 |
| 보안 | 2/10 | CRITICAL 3건 미수정. Storage Rules 전무, 인증 가드 전무 |
| 법적 컴플라이언스 | 2/10 | APPI 데이터 삭제 의무 위반, Privacy Policy URL 플레이스홀더 |
| App Store 준비도 | 1/10 | TestFlight 미시도, 스크린샷 없음, 계정 삭제 서버 미구현 |
| 사용자 경험 검증 | 0/10 | 컨슈머 패널 4개 게이트 전혀 미실시 |
| 기능 완성도 | 6/10 | 핵심 기능은 구현됨. 여행 모드, 보호자 연동 등 명세 대비 존재 |

**가중 종합**: **3.5/10 — NO-GO**

---

## 2. 출시 블로커 (BLOCKER) — 이것 없이는 제출 불가

### BLOCKER-1: C-1 — 서버사이드 계정 삭제 미구현 (즉시 App Store 리젝)

**현황**: `auth_service.dart`는 Firebase Auth 계정만 삭제한다. Firestore 문서, Storage 파일, Cloud Functions 토큰 등 서버 데이터는 고아(orphaned)로 남는다.

**이유**: Apple App Store 가이드라인 5.1.1(v)는 계정 생성이 있는 앱에 서버사이드 완전 삭제를 의무화한다. 심사자가 계정 삭제 후 데이터가 잔존하는지 확인하면 즉시 리젝된다. 일본 APPI도 사용자 데이터 삭제 요구 시 완전 삭제 의무를 부과한다.

**필요 조치**: `deleteUserAccount` Cloud Function 구현 — Firebase Auth, Firestore 전체 문서 + 서브컬렉션, Storage 파일, FCM 토큰, 외부 서비스 토큰 일괄 삭제.

---

### BLOCKER-2: C-2 — GoRouter 인증 가드 없음 (데이터 노출)

**현황**: `app_router.dart`에 `redirect` 콜백이 없다. Deep link를 통해 비인증 사용자가 홈, 약 목록, 보호자 대시보드 등 민감 화면에 직접 접근 가능하다.

**이유**: 건강 데이터(복약 이력, 보호자 관계)를 다루는 앱에서 인증 가드는 최소 보안 요구사항이다. 심사 중 심사자가 Deep link로 비인증 접근을 시도할 수 있으며, 이는 가이드라인 5.1.1 위반으로 리젝될 수 있다.

**필요 조치**: GoRouter `redirect` 콜백 추가 — 미인증 상태에서 보호 경로 접근 시 `/onboarding`으로 리다이렉트.

---

### BLOCKER-3: C-3 — Firebase Storage Rules 파일 없음 (타 사용자 파일 무제한 접근)

**현황**: `storage.rules` 파일 자체가 존재하지 않는다. 약 사진 등 Storage 객체에 어떤 인증 사용자든 읽기/쓰기/삭제 가능한 상태다.

**이유**: 건강 관련 사진(약 이미지)이 타인에게 노출 가능한 상태로 운영하는 것은 APPI 요배사항 위반이며, 심각한 평판 리스크다. Firebase Storage 기본 규칙은 "모든 인증 사용자에게 허용"이다.

**필요 조치**: `storage.rules` 생성 — 사용자별 경로(`/users/{uid}/`)에 본인만 접근 가능하도록 규칙 설정 후 `firebase deploy --only storage` 배포.

---

### BLOCKER-4: Privacy Policy URL 플레이스홀더 (App Store 제출 필수 메타데이터)

**현황**: `lib/core/constants/`의 Privacy Policy URL이 플레이스홀더다. 설정 화면에서 실제 페이지가 열리지 않는다.

**이유**: App Store Connect는 앱 제출 시 Privacy Policy URL을 필수로 요구한다. 플레이스홀더 URL로 제출하면 메타데이터 검증에서 즉시 반려된다. 또한 APPI는 개인정보 처리 방침 공개를 의무화한다.

**필요 조치**: `kusuridoki.hobbylabo.dev/privacy-policy` 페이지를 Cloudflare Pages에 배포 (일본어 + 영어). 지원 이메일: `support@hobbylabo.dev` 포함.

---

### BLOCKER-5: H-1 — 로그아웃 시 Riverpod Provider 상태 미초기화 (데이터 유출)

**현황**: 로그아웃 시 Provider 캐시가 남아 있어 다음 사용자(공유 기기)에게 이전 사용자의 약 목록, 복약 이력이 노출될 수 있다.

**이유**: 고령자 케어 환경에서 기기 공유는 빈번하다(자식이 부모 기기로 확인). 이전 사용자 데이터 노출은 신뢰 붕괴의 직접적 원인이다.

**필요 조치**: 로그아웃 시 `ref.invalidate()` 또는 앱 재시작 수준의 Provider 전체 초기화.

---

## 3. MVP 최소 출시 기준선

아래 항목이 **모두** 충족될 때 비로소 TestFlight 제출 자격이 생긴다.

### 보안 (Non-negotiable)

| 항목 | 기준 |
|------|------|
| C-1 서버사이드 계정 삭제 | Cloud Function 구현 + 검증 완료 |
| C-2 GoRouter 인증 가드 | redirect 콜백 구현 + Deep link 테스트 |
| C-3 Storage Rules | 파일 생성 + 배포 + 접근 거부 검증 |
| H-1 로그아웃 상태 초기화 | Provider 전체 invalidate 구현 |
| H-2 revokeAccess IDOR | linkId 소유권 검증 추가 |
| H-4 FCM 토큰 로깅 제거 | debugPrint 제거 |

### 법적 컴플라이언스 (Non-negotiable)

| 항목 | 기준 |
|------|------|
| Privacy Policy 페이지 | 실제 URL 게시 (일본어 + 영어) |
| Terms of Service 페이지 | 실제 URL 게시 |
| APPI 준수 명시 | Privacy Policy에 데이터 항목, 보유 기간, 삭제 방법 명기 |

### App Store 준비 (제출 필수)

| 항목 | 기준 |
|------|------|
| TestFlight 배포 | 최소 1회 성공적 빌드 + 내부 테스터 설치 확인 |
| 스크린샷 | iPhone 6.9", 5.5", iPad (요구 사이즈 모두) |
| App Store 메타데이터 | 일본어 설명, 키워드, 카테고리 확정 |
| Release 모드 테스트 | 실제 기기에서 `flutter run --release` 통과 |

### 사용자 경험 검증 (Consumer Panel)

| 게이트 | 기준 |
|--------|------|
| G1 — 핵심 흐름 | 약 등록 → 리마인더 → 복용 체크 흐름 7/10 이상 |
| G2 — 보호자 연동 | 초대 → QR 연동 → 대시보드 조회 7/10 이상 |
| G3 — 고령자 접근성 | 글씨 크기, 버튼 크기, 고대비 7/10 이상 |
| G4 — 전체 출시 심사 | 종합 점수 7/10 이상 |

---

## 4. 리스크 평가

### 법적 리스크 — HIGH

| 리스크 | 수준 | 근거 |
|--------|------|------|
| APPI 위반 (데이터 미삭제) | CRITICAL | 일본 PPC는 2024년부터 벌금 부과 능력 강화. 건강 데이터는 "요배사항 배려 개인정보"로 엄격 규제 |
| App Store 가이드라인 5.1.1(v) 위반 | CRITICAL | 서버사이드 삭제 미구현 시 즉시 리젝, 반복 위반 시 개발자 계정 정지 가능 |
| Privacy Policy 부재 | HIGH | APPI 제17조 공표 의무 위반 |

### 시장 리스크 — MEDIUM

| 리스크 | 수준 | 근거 |
|--------|------|------|
| 일본 시장 진입 경쟁 | MEDIUM | MediSafe, お薬手帳, カロナール 등 기존 앱 존재. 차별점(보호자 무제한 무료, 여행 모드)은 유효하나 신뢰도 확보 전까지 이탈 위험 |
| 고령자 타겟 신뢰도 | MEDIUM | 보안 사고 1건으로 일본 고령자 커뮤니티에서 회복 불가능한 평판 손상 가능 |
| 컨슈머 패널 미실시 | HIGH | 실제 사용자 피드백 없이 출시 시 1성 리뷰 폭격 위험 |

### 기술 리스크 — MEDIUM

| 리스크 | 수준 | 근거 |
|--------|------|------|
| Firebase Storage 규칙 부재 | CRITICAL | 현재 상태로 운영 시 데이터 침해 발생 가능성 실질적 존재 |
| NotificationService 테스트 미비 | MEDIUM | 일본 Android 기기의 배너 최적화 문제 미검증. 핵심 기능인 알림이 Silent fail 가능 |
| IAP 영수증 서버검증 없음 | MEDIUM | M-4 이슈 — 구독 수익 모델 도입 시 즉각 취약점으로 전환 |
| Deep Link 초대 코드 미검증 | MEDIUM | M-6 이슈 — 보호자 연동 핵심 기능의 신뢰성 취약 |

### 평판 리스크 — HIGH (일본 시장 특수성)

일본 앱 마켓의 특성상 초기 리뷰가 장기 다운로드에 결정적 영향을 미친다. 건강 데이터를 다루는 앱에서 보안 사고나 기능 오작동은 "믿을 수 없는 앱"이라는 낙인이 찍히며, 이는 앱 이름 변경으로도 회복하기 어렵다. 컨슈머 패널 없이 출시하는 것은 이 리스크를 고스란히 감수하는 것이다.

---

## 5. 권장 출시 전략 — 단계적 접근 (即時出시 절대 불가)

### 즉시 출시: 불가

현재 상태로 TestFlight조차 제출해서는 안 된다. 보안 CRITICAL 이슈가 미수정된 앱을 외부에 배포하는 것은 실제 사용자 데이터를 리스크에 노출시키는 행위다.

---

### Phase A — 보안 & 컴플라이언스 (예상: 1~2주)

**목표**: 리젝 없이 App Store 심사 통과 가능한 상태

| 작업 | 우선순위 | 담당 |
|------|----------|------|
| C-1: `deleteUserAccount` Cloud Function 구현 | P0 | Backend |
| C-2: GoRouter redirect 인증 가드 | P0 | Frontend |
| C-3: storage.rules 생성 + 배포 | P0 | DevOps |
| H-1: 로그아웃 Provider 초기화 | P0 | Frontend |
| H-2: revokeAccess IDOR 수정 | P1 | Backend |
| H-4: FCM 토큰 로깅 제거 | P1 | Frontend |
| Privacy Policy / ToS 페이지 Cloudflare 배포 | P0 | Ops |

**Phase A 완료 기준**: 보안 리뷰 재실시 → CRITICAL 0건, HIGH 2건 이하

---

### Phase B — TestFlight & 사용자 검증 (예상: 1~2주)

**목표**: 실제 기기 검증 + 사용자 피드백 수집

| 작업 | 우선순위 |
|------|----------|
| Release 모드 빌드 + 실기기 테스트 (iPhone + Android) | P0 |
| TestFlight 내부 테스터 배포 (가족, 지인 5~10명) | P0 |
| Consumer Panel G1~G4 실시 | P0 |
| 스크린샷 캡처 (전 required 사이즈) | P1 |
| App Store Connect 메타데이터 완성 | P1 |
| NotificationService 실기기 통지 검증 | P0 |

**Phase B 완료 기준**: Consumer Panel 전 게이트 7/10 이상 + TestFlight 크리티컬 버그 없음

---

### Phase C — 소프트 런치 (Japan-First)

**목표**: 제한적 출시로 초기 데이터 수집

- App Store / Google Play 일본 지역 한정 출시
- MAU 500 달성 후 리뷰 패턴 분석
- 1성 리뷰 즉각 대응 체계 수립
- MAU 1,000 달성 및 평균 별점 4.0 이상 유지 시 글로벌 출시 검토

---

## 6. 비즈니스 판단 요약

6단계 개선이 완료된 것은 팀의 실행력을 보여주는 긍정적 신호다. 그러나 보안 리뷰 결과는 냉정하다. **CRITICAL 3건이 미수정된 앱을 출시하는 것은 사업 리스크가 아니라 사용자 피해 리스크다.**

약 복용 데이터는 일본 법에서 "배려를 요하는 개인정보(要配慮個人情報)"로 분류된다. 이 카테고리의 데이터를 다루는 앱이 Storage Rules도 없고, 인증 가드도 없고, 계정 삭제 시 데이터가 남는 상태로 운영된다면, 단순한 심사 리젝을 넘어 법적 책임 문제로 비화될 수 있다.

**Phase A 완료 예상 후 재평가 목표 점수: 7.0/10 (GO)**

현재 팀의 속도라면 Phase A는 1~2주 내 완료 가능하다. 서두르지 말고 제대로 하는 것이 옳다.

---

## 연구 출처

- [Apple Developer — Account deletion requirement](https://developer.apple.com/news/?id=12m75xbj)
- [Apple — Offering account deletion in your app](https://developer.apple.com/support/offering-account-deletion-in-your-app/)
- [ICLG — Japan Data Protection 2025-2026](https://iclg.com/practice-areas/data-protection-laws-and-regulations/japan)
- [Japan APPI Comprehensive Guide](https://www.privacyengine.io/blog/2024/11/28/japans-appi-data-protection-law/)
- [Transcend — Apple's In-App Account Deletion](https://transcend.io/blog/apple-requirement-app-account-deletion)
