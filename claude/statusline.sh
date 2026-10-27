#!/usr/bin/env bash
# Claude Code status line — responsive single line
#
# Layout:
#    folder   branch   MODEL ·effort ·flags  BAR used/total (pct%)  $cost
#    +a/-r  cache%    5h: n% BAR (↺hh:mm)    7d: n% BAR (↺Day:hh:mm)
#
# Degradation order (first dropped → last):
#   extras (cache, lines, think/fast/style flags) → branch → folder abbr
#   → folder basename → folder drop → 7d bar → 5h bar → 7d text → 5h text
#
# Requires: jq, git (optional)
#
# Locale note: every number is parsed/formatted under LC_ALL=C. jq emits a
# decimal point, but a nl_NL/de_DE/fr_FR locale makes awk's strtod stop at it,
# which silently truncated the cost to whole units.

# Force C numeric locale so awk parses the API's dot-decimal values (e.g.
# total_cost_usd "0.87") correctly. Under nl_NL.UTF-8, awk treats "," as the
# decimal separator and silently truncates "0.87" to 0 → cost stuck at €0,00.
# LC_TIME is left untouched so day names follow the user's locale.
export LC_NUMERIC=C

input=$(cat)

# Single jq pass — this runs on every render, so avoid a process per field.
# @sh quotes anything that could contain shell metacharacters.
eval "$(printf '%s' "$input" | jq -r '
  (.context_window // {})    as $cw |
  ($cw.current_usage // {})  as $cu |
  (.rate_limits // {})       as $rl |
  (.prompt_cache // {})      as $pc |
  (($cw.context_window_size // 0) | if . > 0 then . else 200000 end) as $total |
  (
    ($cw.total_input_tokens //
      (($cu.input_tokens // 0)
       + ($cu.cache_creation_input_tokens // 0)
       + ($cu.cache_read_input_tokens // 0)))
    + ($cw.total_output_tokens // ($cu.output_tokens // 0))
  ) as $used |
  [
    "M_MODEL=\(.model.display_name // "unknown" | @sh)",
    "M_EFFORT=\(.effort.level // "" | @sh)",
    "M_THINK=\(if .thinking.enabled then 1 else 0 end)",
    "M_FAST=\(if .fast_mode then 1 else 0 end)",
    "M_STYLE=\(.output_style.name // "default" | @sh)",
    "M_TOTAL=\($total)",
    "M_USED=\($used)",
    "M_PCT=\(($cw.used_percentage // ($used * 100 / $total)) | round)",
    "M_PERMIL=\(($used * 1000 / $total) | floor)",
    "M_EXCEEDS=\(if .exceeds_200k_tokens then 1 else 0 end)",
    "M_CENTS=\((.cost.total_cost_usd // 0) * 100 | round)",
    "M_ADDED=\(.cost.total_lines_added // 0)",
    "M_REMOVED=\(.cost.total_lines_removed // 0)",
    "M_CACHE_PRESENT=\(if (.prompt_cache | type) == "object" then 1 else 0 end)",
    "M_CACHE_WARM=\(if $pc.warm then 1 else 0 end)",
    "M_CACHE_HIT=\((($pc.hit_ratio // 0) * 100) | round)",
    "M_RL5=\(($rl.five_hour.used_percentage // 0) | round)",
    "M_RL5_PERMIL=\((($rl.five_hour.used_percentage // 0) * 10) | round)",
    "M_RL5_RESET=\($rl.five_hour.resets_at // 0 | tostring | @sh)",
    "M_RL7=\(($rl.seven_day.used_percentage // 0) | round)",
    "M_RL7_PERMIL=\((($rl.seven_day.used_percentage // 0) * 10) | round)",
    "M_RL7_RESET=\($rl.seven_day.resets_at // 0 | tostring | @sh)",
    "M_CWD=\(.workspace.current_dir // .cwd // "" | @sh)"
  ] | .[]
')"

MODEL="${M_MODEL% (*}"
[ -z "$MODEL" ] && MODEL="unknown"

CWD="$M_CWD"
[ -z "$CWD" ] && CWD="$PWD"

# total_cost_usd is USD — label it as such rather than €.
COST=$(printf '%d.%02d' "$(( M_CENTS / 100 ))" "$(( M_CENTS % 100 ))")

# Normalize resets_at (Unix epoch int OR ISO 8601 string) to epoch seconds.
# Returns empty string for zero/unparseable input.
to_epoch() {
  local ts=$1
  case "$ts" in
    ''|0|null) return ;;
    *[!0-9]*)
      date -j -u -f "%Y-%m-%dT%H:%M:%SZ" "$ts" "+%s" 2>/dev/null \
        || date -u -d "$ts" "+%s" 2>/dev/null
      ;;
    *) echo "$ts" ;;
  esac
}
fmt_reset() {
  local epoch; epoch=$(to_epoch "$1")
  [ -z "$epoch" ] && { echo "--:--"; return; }
  date -r "$epoch" +%H:%M 2>/dev/null || date -d "@$epoch" +%H:%M 2>/dev/null
}
fmt_reset_day() {
  local epoch; epoch=$(to_epoch "$1")
  [ -z "$epoch" ] && { echo "---:--"; return; }
  local day time
  # LC_ALL=C keeps the day abbreviation English, matching the rest of the line.
  day=$(LC_ALL=C date -r "$epoch" +%a 2>/dev/null || LC_ALL=C date -d "@$epoch" +%a 2>/dev/null)
  time=$(date -r "$epoch" +%H:%M 2>/dev/null || date -d "@$epoch" +%H:%M 2>/dev/null)
  echo "${day}:${time}"
}
RL5_TIME=$(fmt_reset "$M_RL5_RESET")
RL7_TIME=$(fmt_reset_day "$M_RL7_RESET")

c_grey='\e[2m'; c_yellow='\e[33m'; c_red='\e[31m'
c_cyan='\e[1;36m'; c_branch='\e[2;36m'
c_reset='\e[0m'

color() {
  local pct=$1
  if   [ "$pct" -lt 70 ]; then printf '%s' "$c_grey"
  elif [ "$pct" -lt 90 ]; then printf '%s' "$c_yellow"
  else                         printf '%s' "$c_red"
  fi
}

fmt_tokens() {
  local t=$1
  if [ "$t" -ge 1000000 ]; then
    if [ $(( t % 1000000 )) -eq 0 ]; then
      echo "$(( t / 1000000 ))M"
    else
      LC_ALL=C awk -v n="$t" 'BEGIN{printf "%.1fM", n/1000000}'
    fi
  else
    echo "$(( t / 1000 ))k"
  fi
}

# Eighth-width blocks give the bar sub-cell resolution. With a 1M context
# window a whole cell is ~67k tokens, so without this the bar looks frozen.
BLOCKS=('▏' '▎' '▍' '▌' '▋' '▊' '▉' '█')

# make_bar <permille 0-1000> <width>; always emits exactly <width> cells.
make_bar() {
  local permil=$1 width=$2
  [ "$permil" -lt 0 ] && permil=0
  [ "$permil" -gt 1000 ] && permil=1000
  local eighths=$(( permil * width * 8 / 1000 ))
  local full=$(( eighths / 8 ))
  local rem=$(( eighths % 8 ))
  if [ "$full" -ge "$width" ]; then full=$width; rem=0; fi
  local out="" used=$full
  [ "$full" -gt 0 ] && out=$(printf '█%.0s' $(seq 1 $full))
  if [ "$rem" -gt 0 ]; then
    out="${out}${BLOCKS[$((rem-1))]}"
    used=$(( full + 1 ))
  fi
  local empty=$(( width - used ))
  [ "$empty" -gt 0 ] && out="${out}$(printf '░%.0s' $(seq 1 $empty))"
  printf '%s' "$out"
}

GLYPH_GIT=$(printf '\xef\x90\x98')      # U+F418 nf-oct-git_branch
GLYPH_FOLDER=$(printf '\xef\x81\xbb')   # U+F07B nf-fa-folder

FOLDER_FULL=""
IN_REPO=0
FOLDER_HELPER="$HOME/dotfiles/scripts/folder-name.sh"
if FOLDER_FULL=$("$FOLDER_HELPER" --full "$CWD" 2>/dev/null); then
  IN_REPO=1
fi

# The git glyph now labels an actual branch; the path always gets the folder
# glyph. --no-optional-locks keeps the status line off the index lock.
BRANCH=""
if [ "$IN_REPO" = "1" ]; then
  BRANCH=$(git -C "$CWD" --no-optional-locks symbolic-ref --quiet --short HEAD 2>/dev/null) \
    || BRANCH=$(git -C "$CWD" --no-optional-locks rev-parse --short HEAD 2>/dev/null) \
    || BRANCH=""
fi

abbreviate_path() {
  local path=$1 mode=$2
  case "$mode" in
    full) echo "$path"; return ;;
    none) echo ""; return ;;
  esac

  local prefix=""
  if [ "${path:0:1}" = "/" ]; then
    prefix="/"
    path="${path#/}"
  fi

  local IFS='/'
  local -a parts
  read -ra parts <<< "$path"
  local n=${#parts[@]}

  if [ "$mode" = "last" ]; then
    if [ "$n" -le 1 ]; then
      echo "${prefix}${path}"
    else
      echo "${parts[$((n-1))]}"
    fi
    return
  fi

  # abbr: keep first + last components in full, collapse middle to first char
  if [ "$n" -le 2 ]; then
    echo "${prefix}${path}"
    return
  fi

  local result="${prefix}${parts[0]}"
  local i p first_char
  for (( i=1; i<n-1; i++ )); do
    p="${parts[$i]}"
    first_char="${p:0:1}"
    if [ "$first_char" = "." ] && [ "${#p}" -gt 1 ]; then
      result="${result}/.${p:1:1}"
    else
      result="${result}/${first_char}"
    fi
  done
  result="${result}/${parts[$((n-1))]}"
  echo "$result"
}

# Claude Code exports COLUMNS; the other probes only matter if that changes.
# A non-positive COLUMNS must not fall through as a real width — COLS would go
# negative and collapse every segment at once.
COLS=""
case "$COLUMNS" in
  ''|*[!0-9]*) ;;
  *) [ "$COLUMNS" -gt 0 ] && COLS="$COLUMNS" ;;
esac
[ -z "$COLS" ] && COLS=$({ stty size </dev/tty | awk '{print $2}'; } 2>/dev/null)
[ -z "$COLS" ] && COLS=$(tput cols 2>/dev/null)
{ [ -z "$COLS" ] || [ "$COLS" -le 0 ]; } && COLS=200
COLS=$(( COLS - 30 ))  # reserve space for right-aligned tips
MIN_BAR=8
MAX_BAR=30

USED_H=$(fmt_tokens "$M_USED")
TOTAL_H=$(fmt_tokens "$M_TOTAL")

# Plain-text segments (no bars, no ANSI) for length measurement.
FLAGS_CORE=""
[ -n "$M_EFFORT" ] && FLAGS_CORE=" ·${M_EFFORT}"

FLAGS_EXTRA=""
[ "$M_THINK" = "1" ] && FLAGS_EXTRA="${FLAGS_EXTRA} ·think"
[ "$M_FAST"  = "1" ] && FLAGS_EXTRA="${FLAGS_EXTRA} ·fast"
[ "$M_STYLE" != "default" ] && [ -n "$M_STYLE" ] && FLAGS_EXTRA="${FLAGS_EXTRA} ·${M_STYLE}"

TXT_CORE="${MODEL}${FLAGS_CORE}  ${USED_H}/${TOTAL_H} (${M_PCT}%) \$${COST}"

TXT_200K=""
[ "$M_EXCEEDS" = "1" ] && TXT_200K=" 200k+"

TXT_LINES=""
if [ "$M_ADDED" -gt 0 ] || [ "$M_REMOVED" -gt 0 ]; then
  TXT_LINES=" +${M_ADDED}/-${M_REMOVED}"
fi

# Absent prompt_cache (start of a session) is not the same as a cold cache.
TXT_CACHE=""
if [ "$M_CACHE_PRESENT" = "1" ]; then
  if [ "$M_CACHE_WARM" = "1" ]; then
    TXT_CACHE=" cache ${M_CACHE_HIT}%"
  else
    TXT_CACHE=" cache cold"
  fi
fi

TXT_BRANCH=""
[ -n "$BRANCH" ] && TXT_BRANCH="${GLYPH_GIT} ${BRANCH}"

TXT_5H="  5h: ${M_RL5}% (↺${RL5_TIME})"
TXT_7D="  7d: ${M_RL7}% (↺${RL7_TIME})"
# Extra chars per bar slot: " " before bar + " " after = 2
BAR_PADDING=2

# Degradation states — (folder branch extras 5h 7d), first to last resort
STATES=(
  "full on   on   bar  bar"
  "full on   none bar  bar"
  "abbr on   none bar  bar"
  "last on   none bar  bar"
  "last none none bar  bar"
  "none none none bar  bar"
  "none none none bar  text"
  "none none none text text"
  "none none none text none"
  "none none none none none"
)

MODEFD="none"; MODEBR="none"; MODEX="none"
MODE5H="none"; MODE7D="none"; BAR_W=$MIN_BAR
FOLDER_TXT=""

for state in "${STATES[@]}"; do
  read -r mf mb mx m5 m7 <<< "$state"

  num_bars=1  # context bar is always present
  text_w=${#TXT_CORE}
  text_w=$(( text_w + BAR_PADDING ))  # context bar padding
  text_w=$(( text_w + ${#TXT_200K} ))

  folder_txt=$(abbreviate_path "$FOLDER_FULL" "$mf")
  if [ -n "$folder_txt" ]; then
    # glyph + space + path + 2-space separator before the next segment
    text_w=$(( text_w + ${#GLYPH_FOLDER} + 1 + ${#folder_txt} + 2 ))
  fi

  if [ "$mb" = "on" ] && [ -n "$TXT_BRANCH" ]; then
    text_w=$(( text_w + ${#TXT_BRANCH} + 2 ))
  fi

  if [ "$mx" = "on" ]; then
    text_w=$(( text_w + ${#FLAGS_EXTRA} + ${#TXT_LINES} + ${#TXT_CACHE} ))
  fi

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

  available=$(( COLS - text_w ))
  bar_w=$(( available / num_bars ))

  if [ "$bar_w" -ge "$MIN_BAR" ]; then
    BAR_W=$(( bar_w > MAX_BAR ? MAX_BAR : bar_w ))
    MODEFD="$mf"; MODEBR="$mb"; MODEX="$mx"; MODE5H="$m5"; MODE7D="$m7"
    FOLDER_TXT="$folder_txt"
    break
  fi
done

# --- Output ---
[ -n "$FOLDER_TXT" ] && printf "${c_cyan}%s %s${c_reset}  " "$GLYPH_FOLDER" "$FOLDER_TXT"
[ "$MODEBR" = "on" ] && [ -n "$TXT_BRANCH" ] && \
  printf "${c_branch}%s %s${c_reset}  " "$GLYPH_GIT" "$BRANCH"

printf "$(color $M_PCT)%s${c_reset}" "$MODEL"
[ -n "$FLAGS_CORE" ] && printf "${c_grey}%s${c_reset}" "$FLAGS_CORE"
[ "$MODEX" = "on" ] && [ -n "$FLAGS_EXTRA" ] && printf "${c_grey}%s${c_reset}" "$FLAGS_EXTRA"

printf "$(color $M_PCT) %s${c_reset} %s/%s (%s%%) " \
  "$(make_bar $M_PERMIL $BAR_W)" "$USED_H" "$TOTAL_H" "$M_PCT"
printf "${c_grey}\$%s${c_reset}" "$COST"
[ -n "$TXT_200K" ] && printf "${c_yellow}%s${c_reset}" "$TXT_200K"

if [ "$MODEX" = "on" ]; then
  [ -n "$TXT_LINES" ] && printf "${c_grey}%s${c_reset}" "$TXT_LINES"
  [ -n "$TXT_CACHE" ] && printf "${c_grey}%s${c_reset}" "$TXT_CACHE"
fi

if [ "$MODE5H" != "none" ]; then
  if [ "$MODE5H" = "bar" ]; then
    printf "  $(color $M_RL5)5h: %s%% %s (↺%s)${c_reset}" \
      "$M_RL5" "$(make_bar $M_RL5_PERMIL $BAR_W)" "$RL5_TIME"
  else
    printf "  $(color $M_RL5)5h: %s%% (↺%s)${c_reset}" "$M_RL5" "$RL5_TIME"
  fi
fi

if [ "$MODE7D" != "none" ]; then
  if [ "$MODE7D" = "bar" ]; then
    printf "  $(color $M_RL7)7d: %s%% %s (↺%s)${c_reset}" \
      "$M_RL7" "$(make_bar $M_RL7_PERMIL $BAR_W)" "$RL7_TIME"
  else
    printf "  $(color $M_RL7)7d: %s%% (↺%s)${c_reset}" "$M_RL7" "$RL7_TIME"
  fi
fi

printf '\n'
