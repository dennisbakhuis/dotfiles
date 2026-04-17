#!/usr/bin/env bash
# Claude Code status line — responsive single line
# Degradation order: 7d bar → 5h bar → 7d → 5h → core only
# Requires: jq

input=$(cat)

MODEL=$(echo "$input"  | jq -r '.model.display_name // "unknown"')
USED=$(echo "$input"   | jq -r '.context_window.current_usage.input_tokens // .context_window.total_input_tokens // 0')
TOTAL=$(echo "$input"  | jq -r '.context_window.context_window_size // 200000')
PCT=$(echo "$input"    | jq -r '.context_window.used_percentage // 0' | awk '{printf "%.0f", $1}')
FREE=$((TOTAL - USED))
COST=$(echo "$input"   | jq -r '.cost.total_cost_usd // 0' | awk '{printf "%.2f", $1}')

RL5_PCT=$(echo "$input"   | jq -r '.rate_limits.five_hour.used_percentage // 0'  | awk '{printf "%.0f", $1}')
RL5_RESET=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // 0')
RL7_PCT=$(echo "$input"   | jq -r '.rate_limits.seven_day.used_percentage // 0'  | awk '{printf "%.0f", $1}')
RL7_RESET=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // 0')

fmt_reset() {
  local ts=$1
  [ "$ts" -eq 0 ] 2>/dev/null && echo "--:--" && return
  date -r "$ts" +%H:%M 2>/dev/null || date -d "@$ts" +%H:%M 2>/dev/null
}
RL5_TIME=$(fmt_reset "$RL5_RESET")
RL7_TIME=$(fmt_reset "$RL7_RESET")

c_green='\e[32m'; c_yellow='\e[33m'; c_red='\e[31m'
c_dim='\e[2m'; c_reset='\e[0m'

color() {
  local pct=$1
  if   [ "$pct" -lt 50 ]; then printf '%s' "$c_green"
  elif [ "$pct" -lt 80 ]; then printf '%s' "$c_yellow"
  else                         printf '%s' "$c_red"
  fi
}

make_bar() {
  local pct=$1 width=$2
  local filled=$(( pct * width / 100 ))
  local empty=$(( width - filled ))
  [ $filled -gt 0 ] && printf '█%.0s' $(seq 1 $filled)
  [ $empty  -gt 0 ] && printf '░%.0s' $(seq 1 $empty)
}

COLS=$(tput cols 2>/dev/null || echo 80)
RL_BAR_W=8      # fixed width for rate limit mini-bars
MIN_CTX_BAR=8   # minimum context bar width
MAX_CTX_BAR=30  # don't let it grow absurdly wide

FREE_K="$((FREE/1000))"
TOTAL_K="$((TOTAL/1000))"

# Core string without the context bar (for length measurement)
CORE_NOBAR="${MODEL}  ${FREE_K}k/${TOTAL_K}k (${PCT}%) €${COST}"

# Precompute plain-text suffix lengths (no ANSI)
rl_bar() { printf "$(make_bar $1 $RL_BAR_W)"; }
S5_BAR="  5h: ${RL5_PCT}% $(rl_bar $RL5_PCT) (↺${RL5_TIME})"
S5_TXT="  5h: ${RL5_PCT}% (↺${RL5_TIME})"
S7_BAR="  7d: ${RL7_PCT}% $(rl_bar $RL7_PCT) (↺${RL7_TIME})"
S7_TXT="  7d: ${RL7_PCT}% (↺${RL7_TIME})"

# Degradation states — (5h_mode 7d_mode), first to last resort
# Removal order: 7d bar, 5h bar, 7d, 5h
STATES=(
  "bar bar"
  "bar text"
  "text text"
  "text none"
  "none none"
)

# Defaults if terminal is extremely narrow
MODE5H="none"; MODE7D="none"; CTX_BAR_W=$MIN_CTX_BAR

for state in "${STATES[@]}"; do
  m5=${state%% *}; m7=${state##* }

  suffix=""
  [ "$m5" = "bar"  ] && suffix="${suffix}${S5_BAR}"
  [ "$m5" = "text" ] && suffix="${suffix}${S5_TXT}"
  [ "$m7" = "bar"  ] && suffix="${suffix}${S7_BAR}"
  [ "$m7" = "text" ] && suffix="${suffix}${S7_TXT}"

  # Space left for the context bar (core + " " + bar + " " + suffix)
  available=$(( COLS - ${#CORE_NOBAR} - 2 - ${#suffix} ))

  if [ "$available" -ge "$MIN_CTX_BAR" ]; then
    CTX_BAR_W=$(( available > MAX_CTX_BAR ? MAX_CTX_BAR : available ))
    MODE5H="$m5"; MODE7D="$m7"
    break
  fi
done

CTX_BAR=$(make_bar "$PCT" "$CTX_BAR_W")

# --- Output ---
printf "$(color $PCT)%s ${CTX_BAR}${c_reset} %sk/%sk (%s%%) " \
  "$MODEL" "$FREE_K" "$TOTAL_K" "$PCT"
printf "${c_dim}€%s${c_reset}" "$COST"

if [ "$MODE5H" != "none" ]; then
  if [ "$MODE5H" = "bar" ]; then
    printf "  $(color $RL5_PCT)5h: %s%% %s (↺%s)${c_reset}" \
      "$RL5_PCT" "$(make_bar $RL5_PCT $RL_BAR_W)" "$RL5_TIME"
  else
    printf "  $(color $RL5_PCT)5h: %s%% (↺%s)${c_reset}" "$RL5_PCT" "$RL5_TIME"
  fi
fi

if [ "$MODE7D" != "none" ]; then
  if [ "$MODE7D" = "bar" ]; then
    printf "  ${c_dim}$(color $RL7_PCT)7d: %s%% %s (↺%s)${c_reset}" \
      "$RL7_PCT" "$(make_bar $RL7_PCT $RL_BAR_W)" "$RL7_TIME"
  else
    printf "  ${c_dim}$(color $RL7_PCT)7d: %s%% (↺%s)${c_reset}" "$RL7_PCT" "$RL7_TIME"
  fi
fi

printf '\n'
