---
name: warn-debug-code
enabled: true
event: file
conditions:
  - field: file_path
    operator: regex_match
    pattern: \.dart$
  - field: new_text
    operator: regex_match
    pattern: \bprint\(|debugPrint\(|log\(.*\)|developer\.log\(
action: warn
---

⚠️ **디버그 코드 감지**

Dart 파일에 디버그용 출력 코드가 추가되고 있습니다.

**감지된 패턴:** `print()`, `debugPrint()`, `log()`, `developer.log()`

**권장 사항:**
- 디버깅 완료 후 반드시 제거
- 프로덕션 코드에는 `logger` 패키지 사용 권장
- 커밋 전 디버그 코드 잔존 여부 확인
