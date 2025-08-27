#!/usr/bin/env bash
# <bitbar.title>Claude Token % (active block)</bitbar.title>
# <bitbar.version>6.0</bitbar.version>
# <bitbar.author>ivory</bitbar.author>
# <bitbar.desc>Show current 5h block I/O token % and reset time</bitbar.desc>

set -euo pipefail

CCUSAGE="${CCUSAGE_CMD:-/Users/USER_NAME/.nvm/versions/node/v20.19.4/bin/ccusage}"
JQ="$(command -v jq || echo /usr/bin/jq)"
TZ_ID="Asia/Seoul"

# 블록 한도(분모) — 필요 시 환경변수로 덮어쓰기: export BLOCK_LIMIT_TOKENS=88000
BLOCK_LIMIT="${BLOCK_LIMIT_TOKENS:-88000}"

# 활성 블록 JSON(내림차순 정렬에서 isActive 우선, 없으면 최신 블록)
BLOCK_JSON="$(
  "$CCUSAGE" blocks --json -z "$TZ_ID" -o desc 2>/dev/null \
  | "$JQ" -c '
      ( .blocks[]? | select(.isActive==true) ) // .blocks[0]
    ' 2>/dev/null || echo ""
)"

if [[ -z "$BLOCK_JSON" || "$BLOCK_JSON" == "null" ]]; then
  echo "Claude: …"
  echo '---'
  echo "No active/last block JSON"
  echo "Refresh | refresh=true"
  exit 0
fi

# I/O 토큰 합 (input + output)
IO_TOKENS="$(printf '%s' "$BLOCK_JSON" | "$JQ" -r '
  ((.tokenCounts.inputTokens // 0) + (.tokenCounts.outputTokens // 0))
')"

# 퍼센트 계산 (소수 1자리)
PCT="?"
if [[ "$BLOCK_LIMIT" =~ ^[0-9]+$ ]] && (( BLOCK_LIMIT > 0 )); then
  PCT="$(awk -v u="$IO_TOKENS" -v l="$BLOCK_LIMIT" 'BEGIN{printf("%.1f", (u/l)*100)}')"
fi

# 리셋 시각: endTime → Asia/Seoul 로컬 "h:mm AM/PM"
RESET_ISO="$(printf '%s' "$BLOCK_JSON" | "$JQ" -r '.endTime // empty')"
RESET_LOCAL="N/A"
if [[ -n "$RESET_ISO" && "$RESET_ISO" != "null" ]]; then
  RESET_LOCAL="$(/usr/bin/env python3 - "$RESET_ISO" <<'PY'
import sys
from datetime import datetime, timezone
try:
    import zoneinfo
except Exception:
    from backports import zoneinfo

iso = sys.argv[1].strip()
if not iso or iso == "null":
    print("N/A"); sys.exit(0)
if iso.endswith('Z'):
    dt = datetime.fromisoformat(iso[:-1]).replace(tzinfo=timezone.utc)
else:
    dt = datetime.fromisoformat(iso)
local = dt.astimezone(zoneinfo.ZoneInfo("Asia/Seoul"))
s = local.strftime("%I:%M %p")
print(s.lstrip("0"))
PY
)"
fi

# (옵션) 남은 분 표시: projection.remainingMinutes 있으면
REMAIN_MIN="$(printf '%s' "$BLOCK_JSON" | "$JQ" -r '.projection.remainingMinutes // empty')"

# ── 출력 ─────────────────────────────────────────────────────
# 상단: 퍼센트 · 리셋시각
echo "💠 Claude: ${PCT}% ⏰ ${RESET_LOCAL}"
echo '---'
echo "This block I/O: ${IO_TOKENS} / ${BLOCK_LIMIT} (≈ ${PCT}%)"
echo "Limit resets at: ${RESET_LOCAL}"
if [[ -n "${REMAIN_MIN:-}" && "$REMAIN_MIN" != "null" ]]; then
  echo "Time left: ${REMAIN_MIN} min"
fi
echo '---'
echo "Refresh | refresh=true"