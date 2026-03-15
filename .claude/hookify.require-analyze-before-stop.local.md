---
name: require-analyze-before-stop
enabled: true
event: stop
pattern: .*
action: warn
---

🔍 **완료 전 체크리스트**

작업을 종료하기 전에 다음을 확인하세요:

- [ ] `flutter analyze` 실행하여 정적 분석 통과 확인
- [ ] `flutter test` 실행하여 테스트 통과 확인
- [ ] 코드 생성이 필요한 경우 `dart run build_runner build --delete-conflicting-outputs` 실행
- [ ] 변경한 파일의 import/export가 정상인지 확인

위 항목을 모두 확인하지 않았다면 종료하지 마세요.
