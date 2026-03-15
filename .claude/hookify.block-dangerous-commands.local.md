---
name: block-dangerous-commands
enabled: true
event: bash
pattern: rm\s+-rf|chmod\s+777|git\s+push\s+--force|git\s+push\s+-f\b|git\s+reset\s+--hard
action: block
---

🚫 **위험한 명령어가 감지되었습니다!**

다음 명령어는 차단됩니다:
- `rm -rf` — 재귀적 강제 삭제 (복구 불가)
- `chmod 777` — 모든 권한 부여 (보안 위험)
- `git push --force` — 원격 히스토리 덮어쓰기
- `git reset --hard` — 커밋되지 않은 변경사항 손실

**대안:**
- 삭제: 특정 파일만 지정하거나 `rm -i`(확인 모드) 사용
- 권한: 최소 권한 원칙 적용 (예: `chmod 644`)
- Git: `git push --force-with-lease` 또는 새 커밋으로 되돌리기
- Reset: `git stash`로 변경사항 보관 후 진행
