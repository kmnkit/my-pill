---
name: warn-sensitive-files
enabled: true
event: file
conditions:
  - field: file_path
    operator: regex_match
    pattern: \.env$|\.env\.|credentials|secret|\.pem$|\.key$|google-services\.json$|GoogleService-Info\.plist$
action: warn
---

⚠️ **민감한 파일 수정 감지**

이 파일에는 비밀키, 인증 정보, 또는 민감한 설정이 포함될 수 있습니다.

**확인 사항:**
- 비밀키나 토큰이 하드코딩되어 있지 않은지 확인
- `.gitignore`에 포함되어 있는지 확인
- 변경이 정말 필요한지 재검토
