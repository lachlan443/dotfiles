#!/bin/bash
# Claude Code status line: model | dir (branch) | ctx | 5h limit | weekly limit and where it is heading by reset.
input=$(cat)
j() { echo "$input" | jq -r "$1"; }

model=$(j '.model.display_name // "?"' | sed -E 's/ \([^)]*\)$//')
effort=$(j '.effort.level // empty')
[ -n "$effort" ] && model="${model} (${effort})"
cwd=$(j '.workspace.current_dir // .cwd // "?"')
dir_name=$(basename "$cwd")
branch=""
if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
fi

DIM='\033[2;37m'; CYAN='\033[2;36m'; YELLOW='\033[2;33m'; GREEN='\033[32m'; RED='\033[31m'; RESET='\033[0m'
SEP="${DIM} | ${RESET}"

line="${DIM}${model}${RESET}${SEP}${CYAN}${dir_name}${RESET}"
[ -n "$branch" ] && line="${line}${DIM} (${RESET}${YELLOW}${branch}${RESET}${DIM})${RESET}"

used_pct=$(j '.context_window.used_percentage // empty')
[ -n "$used_pct" ] && line="${line}${SEP}${DIM}$(printf '%.0f%% ctx' "$used_pct")${RESET}"

five_pct=$(j '.rate_limits.five_hour.used_percentage // empty')
five_reset=$(j '.rate_limits.five_hour.resets_at // empty')
if [ -n "$five_pct" ] && [ -n "$five_reset" ]; then
  # Projected usage at reset: used so far / share of the 5-hour window gone (wall clock).
  # Held back for the first 15 minutes, when one task swings it wildly.
  five_used=$(printf '%.0f' "$five_pct")
  five_when=$(date -r "$five_reset" '+%H:%M')
  five_gone=$(( $(date +%s) - (five_reset - 18000) ))
  if [ "$five_gone" -ge 900 ]; then
    five_proj=$(( five_used * 18000 / five_gone ))
    colour=$GREEN
    [ "$five_proj" -gt 100 ] && colour=$RED
    line="${line}${SEP}${DIM}${five_used}% → ${RESET}${colour}${five_proj}%${RESET}${DIM} (${five_when})${RESET}"
  else
    line="${line}${SEP}${DIM}${five_used}% (${five_when})${RESET}"
  fi
fi

week_pct=$(j '.rate_limits.seven_day.used_percentage // empty')
week_reset=$(j '.rate_limits.seven_day.resets_at // empty')
if [ -n "$week_pct" ] && [ -n "$week_reset" ]; then
  # Projected usage at reset: used so far / share of the window's business hours
  # (Mon-Fri 09:00-17:00 local) already gone. Empty before any business hour has passed.
  projected=$(python3 - "$week_reset" "$week_pct" <<'PY'
import sys, datetime as dt
end = dt.datetime.fromtimestamp(int(sys.argv[1]))
start = end - dt.timedelta(days=7)
now = min(max(dt.datetime.now(), start), end)
def work_secs(a, b):
    total, day = 0.0, a.replace(hour=0, minute=0, second=0, microsecond=0)
    while day < b:
        if day.weekday() < 5:
            lo, hi = max(a, day.replace(hour=9)), min(b, day.replace(hour=17))
            total += max(0.0, (hi - lo).total_seconds())
        day += dt.timedelta(days=1)
    return total
gone = work_secs(start, now) / work_secs(start, end)
if gone > 0:
    print(round(float(sys.argv[2]) / gone))
PY
)
  week_used=$(printf '%.0f%%' "$week_pct")
  week_when=$(date -r "$week_reset" '+%a %H:%M')
  if [ -n "$projected" ]; then
    colour=$GREEN
    [ "$projected" -gt 100 ] && colour=$RED
    line="${line}${SEP}${DIM}${week_used} → ${RESET}${colour}${projected}%${RESET}${DIM} (${week_when})${RESET}"
  else
    line="${line}${SEP}${DIM}${week_used} (${week_when})${RESET}"
  fi
fi

printf '%b' "$line"
