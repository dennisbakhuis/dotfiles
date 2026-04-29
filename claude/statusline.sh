#!/usr/bin/env bash
# Claude Code status line — responsive single line
# Degradation order: 7d bar → 5h bar → 7d → 5h → core only
# Requires: jq

input=$(cat)

MODEL=$(echo "$input"  | jq -r '.model.display_name // "unknown"')
MODEL="${MODEL% (*}"
TOTAL=$(echo "$input"  | jq -r '.context_window.context_window_size // 200000')
USED_TOKENS=$(echo "$input" | jq -r '
  .context_window.current_usage |
  (.input_tokens // 0) +
  (.cache_creation_input_tokens // 0) +
  (.cache_read_input_tokens // 0)
')
[ -z "$USED_TOKENS" ] || [ "$USED_TOKENS" = "null" ] && USED_TOKENS=0
PCT=$(( USED_TOKENS * 100 / TOTAL ))
COST=$(echo "$input"   | jq -r '.cost.total_cost_usd // 0' | awk '{printf "%.2f", $1}')

RL5_PCT=$(echo "$input"   | jq -r '.rate_limits.five_hour.used_percentage // 0'  | awk '{printf "%.0f", $1}')
RL5_RESET=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // 0')
RL7_PCT=$(echo "$input"   | jq -r '.rate_limits.seven_day.used_percentage // 0'  | awk '{printf "%.0f", $1}')
RL7_RESET=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // 0')

# Normalize resets_at (Unix epoch int OR ISO 8601 string) to epoch seconds.
# Returns empty string for zero/unparseable input.
to_epoch() {
  local ts=$1
  case "$ts" in
    ''|0|null) return ;;
    *[!0-9]*)
      # Non-numeric: assume ISO 8601 UTC like "2026-04-23T18:00:00Z"
      date -j -u -f "%Y-%m-%dT%H:%M:%SZ" "$ts" "+%s" 2>/dev/null \
        || date -u -d "$ts" "+%s" 2>/dev/null
      ;;
    *) echo "$ts" ;;
  esac
}
fmt_reset() {
  local epoch; epoch=$(to_epoch "$1")
  [ -z "$epoch" ] && echo "--:--" && return
  date -r "$epoch" +%H:%M 2>/dev/null || date -d "@$epoch" +%H:%M 2>/dev/null
}
fmt_reset_day() {
  local epoch; epoch=$(to_epoch "$1")
  [ -z "$epoch" ] && echo "---:--" && return
  local day time
  day=$(date -r "$epoch" +%a 2>/dev/null || date -d "@$epoch" +%a 2>/dev/null)
  time=$(date -r "$epoch" +%H:%M 2>/dev/null || date -d "@$epoch" +%H:%M 2>/dev/null)
  echo "${day}:${time}"
}
RL5_TIME=$(fmt_reset "$RL5_RESET")
RL7_TIME=$(fmt_reset_day "$RL7_RESET")

c_grey='\e[2m'; c_yellow='\e[33m'; c_red='\e[31m'
c_reset='\e[0m'

color() {
  local pct=$1
  if   [ "$pct" -lt 70 ]; then printf '%s' "$c_grey"
  elif [ "$pct" -lt 90 ]; then printf '%s' "$c_yellow"
  else                         printf '%s' "$c_red"
  fi
}

fmt_tokens() {
  local tokens=$1
  if [ "$tokens" -ge 1000000 ]; then
    echo "$(( tokens / 1000000 ))M"
  else
    echo "$(( tokens / 1000 ))k"
  fi
}

make_bar() {
  local pct=$1 width=$2
  local filled=$(( pct * width / 100 ))
  local empty=$(( width - filled ))
  [ $filled -gt 0 ] && printf '█%.0s' $(seq 1 $filled)
  [ $empty  -gt 0 ] && printf '░%.0s' $(seq 1 $empty)
}

COLS=$(stty size </dev/tty 2>/dev/null | awk '{print $2}')
[ -z "$COLS" ] && COLS=$(tput cols 2>/dev/null || echo 80)
COLS=$(( COLS - 30 ))  # reserve space for right-aligned tips
MIN_BAR=8       # minimum bar width
MAX_BAR=30      # maximum bar width

USED_H=$(fmt_tokens "$USED_TOKENS")
TOTAL_H=$(fmt_tokens "$TOTAL")

# Plain-text segments (no bars, no ANSI) for length measurement
TXT_CORE="${MODEL}  ${USED_H}/${TOTAL_H} (${PCT}%) €${COST}"
TXT_5H="  5h: ${RL5_PCT}% (↺${RL5_TIME})"
TXT_7D="  7d: ${RL7_PCT}% (↺${RL7_TIME})"
# Extra chars per bar slot: " " before bar + " " after = 2
BAR_PADDING=2

# Degradation states — (5h_mode 7d_mode), first to last resort
STATES=(
  "bar bar"
  "bar text"
  "text text"
  "text none"
  "none none"
)

MODE5H="none"; MODE7D="none"; BAR_W=$MIN_BAR

for state in "${STATES[@]}"; do
  m5=${state%% *}; m7=${state##* }

  # Count bars and text-only width for this state
  num_bars=1  # context bar is always present
  text_w=${#TXT_CORE}
  text_w=$(( text_w + BAR_PADDING ))  # context bar padding

  if [ "$m5" = "bar" ]; then
    num_bars=$(( num_bars + 1 ))
    text_w=$(( text_w + ${#TXT_5H} + BAR_PADDING ))
  elif [ "$m5" = "text" ]; then
    text_w=$(( text_w + ${#TXT_5H} ))
  fi

  if [ "$m7" = "bar" ]; then
    num_bars=$(( num_bars + 1 ))
    text_w=$(( text_w + ${#TXT_7D} + BAR_PADDING ))
  elif [ "$m7" = "text" ]; then
    text_w=$(( text_w + ${#TXT_7D} ))
  fi

  # Divide remaining space equally among all bars
  available=$(( COLS - text_w ))
  bar_w=$(( available / num_bars ))

  if [ "$bar_w" -ge "$MIN_BAR" ]; then
    BAR_W=$(( bar_w > MAX_BAR ? MAX_BAR : bar_w ))
    MODE5H="$m5"; MODE7D="$m7"
    break
  fi
done

# --- Output ---
printf "$(color $PCT)%s %s${c_reset} %s/%s (%s%%) " \
  "$MODEL" "$(make_bar $PCT $BAR_W)" "$USED_H" "$TOTAL_H" "$PCT"
printf "${c_grey}€%s${c_reset}" "$COST"

if [ "$MODE5H" != "none" ]; then
  if [ "$MODE5H" = "bar" ]; then
    printf "  $(color $RL5_PCT)5h: %s%% %s (↺%s)${c_reset}" \
      "$RL5_PCT" "$(make_bar $RL5_PCT $BAR_W)" "$RL5_TIME"
  else
    printf "  $(color $RL5_PCT)5h: %s%% (↺%s)${c_reset}" "$RL5_PCT" "$RL5_TIME"
  fi
fi

if [ "$MODE7D" != "none" ]; then
  if [ "$MODE7D" = "bar" ]; then
    printf "  $(color $RL7_PCT)7d: %s%% %s (↺%s)${c_reset}" \
      "$RL7_PCT" "$(make_bar $RL7_PCT $BAR_W)" "$RL7_TIME"
  else
    printf "  $(color $RL7_PCT)7d: %s%% (↺%s)${c_reset}" "$RL7_PCT" "$RL7_TIME"
  fi
fi

printf '\n'
