#!/usr/bin/env bash
# ~/.config/statusline/statusline.sh
#
# Global terminal status line.
# Shows: 5-hour rate-limit usage bar | 7-day rate-limit usage bar | context-window usage bar | git branch
#
# Color thresholds (edit these two numbers to tune sensitivity):
#   GREEN  : pct <  70
#   YELLOW : 70 <= pct < 90
#   RED    : pct >= 90
#
# Bar sizing: each bar's width is solved from the live terminal width minus
# the fixed-width chrome (labels, brackets, percentages, separators, branch
# name), then clamped to [MIN_BAR, MAX_BAR] so it never collapses or sprawls.

set -u

MIN_BAR=6
MAX_BAR=30

input=$(cat)

RESET=$'\033[0m'
GREEN=$'\033[1;92m'
YELLOW=$'\033[1;93m'
RED=$'\033[1;91m'
GRAY=$'\033[2;37m'
DIM_GRAY=$'\033[2;90m'
BRIGHT_BLUE_BOLD=$'\033[1;94m'
WALL='┃'

# Returns an ANSI color code for a given integer percentage.
pick_color() {
  local pct="$1"
  if [ "$pct" -lt 70 ]; then
    printf '%s' "$GREEN"
  elif [ "$pct" -lt 90 ]; then
    printf '%s' "$YELLOW"
  else
    printf '%s' "$RED"
  fi
}

# Renders a $width-wide glyph bar for integer percentage $pct, colored $color.
# Filled portion uses 1/8-block unicode characters for a smooth (non-blocky)
# fill edge; math done in jq. Untouched portion uses sparse middle-dots in a
# dim/faint style so it reads as background, not just a lighter fill color.
render_bar() {
  local pct="$1" width="$2" color="$3"
  [ "$pct" -lt 0 ] && pct=0
  [ "$pct" -gt 100 ] && pct=100

  local full eighth
  IFS=$'\t' read -r full eighth <<< "$(jq -rn --argjson pct "$pct" --argjson width "$width" '
    ($pct / 100 * $width) as $exact
    | ($exact | floor) as $f
    | (($exact - $f) * 8 | round) as $e
    | if $e >= 8 then "\($f + 1)\t0" else "\($f)\t\($e)" end
  ')"

  local glyphs=(" " "▏" "▎" "▍" "▌" "▋" "▊" "▉" "█")
  local filled="" i
  for ((i = 0; i < full && i < width; i++)); do filled+="█"; done
  if [ "$eighth" -gt 0 ] && [ "$full" -lt "$width" ]; then
    filled+="${glyphs[$eighth]}"
    full=$((full + 1))
  fi
  local empty=$((width - full)) empty_str=""
  for ((i = 0; i < empty; i++)); do empty_str+="·"; done
  printf '%s%s%s%s%s%s' "$color" "$filled" "$RESET" "$DIM_GRAY" "$empty_str" "$RESET"
}

# ---- terminal width ----
term_width=$(tput cols 2>/dev/null || echo "${COLUMNS:-80}")
[ -z "$term_width" ] && term_width=80

# ---- 5-hour rate limit usage (rate_limits.five_hour.used_percentage) ----
five_raw=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
have_five=0
if [ -n "$five_raw" ]; then
  have_five=1
  five_int=$(printf '%.0f' "$five_raw" 2>/dev/null || echo 0)
fi

# ---- 5-hour reset countdown (rate_limits.five_hour.resets_at, unix epoch secs) ----
five_reset_raw=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
have_five_reset=0
reset_chrome=0
if [ -n "$five_reset_raw" ]; then
  five_reset_epoch=$(printf '%.0f' "$five_reset_raw" 2>/dev/null || echo 0)
  now_epoch=$(date +%s)
  remaining=$((five_reset_epoch - now_epoch))
  [ "$remaining" -lt 0 ] && remaining=0
  # 5h window caps remaining at < 5h, so hours is always a single digit -> fixed width "Xh YYm"
  reset_hms=$(printf '%dh%02dm' $((remaining / 3600)) $(((remaining % 3600) / 60)))
  have_five_reset=1
  reset_chrome=8 # " (" + "Xh YYm" (5 chars) + ")"
fi

# ---- 7-day (all models, weekly) rate limit usage (rate_limits.seven_day.used_percentage) ----
seven_raw=$(printf '%s' "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
have_seven=0
if [ -n "$seven_raw" ]; then
  have_seven=1
  seven_int=$(printf '%.0f' "$seven_raw" 2>/dev/null || echo 0)
fi

# ---- 7-day reset countdown (rate_limits.seven_day.resets_at, unix epoch secs) ----
# Shown as hours+minutes only (no day component) even though the window spans up to 7 days.
seven_reset_raw=$(printf '%s' "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
have_seven_reset=0
reset_chrome_seven=0
if [ -n "$seven_reset_raw" ]; then
  seven_reset_epoch=$(printf '%.0f' "$seven_reset_raw" 2>/dev/null || echo 0)
  now_epoch=$(date +%s)
  seven_remaining=$((seven_reset_epoch - now_epoch))
  [ "$seven_remaining" -lt 0 ] && seven_remaining=0
  seven_reset_hms=$(printf '%dh%02dm' $((seven_remaining / 3600)) $(((seven_remaining % 3600) / 60)))
  have_seven_reset=1
  reset_chrome_seven=10 # " (" + up to "167h59m" (7 chars) + ")" worst case
fi

# ---- context window usage (context_window.used_percentage) ----
ctx_raw=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')
have_ctx=0
if [ -n "$ctx_raw" ]; then
  have_ctx=1
  ctx_int=$(printf '%.0f' "$ctx_raw" 2>/dev/null || echo 0)
fi

# ---- active model (model.display_name) ----
model_name=$(printf '%s' "$input" | jq -r '.model.display_name // .model.id // empty')
model_str="${BRIGHT_BLUE_BOLD}✦ ${model_name}${RESET}"

# ---- git branch (not provided directly in the payload; derive it) ----
cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // empty')
branch=""
if [ -n "$cwd" ] && git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
fi
branch_text="${branch:-no-git}"

# ---- solve bar width from remaining terminal space ----
# fixed chrome per segment: "5h ┃" + "┃ 100%" = 4 + 6 = 10
# fixed chrome per segment: "7d ┃" + "┃ 100%" = 4 + 6 = 10
# fixed chrome per segment: "ctx ┃" + "┃ 100%" = 5 + 6 = 11
# three " │ " separators = 9
reserved=$((10 + 10 + 11 + 9 + ${#branch_text} + reset_chrome + reset_chrome_seven + ${#model_name} + 5))
avail=$((term_width - reserved))
bar_width=$((avail / 3))
[ "$bar_width" -lt "$MIN_BAR" ] && bar_width=$MIN_BAR
[ "$bar_width" -gt "$MAX_BAR" ] && bar_width=$MAX_BAR

# ---- compose ----
if [ "$have_five" -eq 1 ]; then
  five_color=$(pick_color "$five_int")
  five_bar=$(render_bar "$five_int" "$bar_width" "$five_color")
  five_str=$(printf '5h %s%s%s %s%3d%%%s' "$WALL" "$five_bar" "$WALL" "$five_color" "$five_int" "$RESET")
  if [ "$have_five_reset" -eq 1 ]; then
    five_str="${five_str} (${BRIGHT_BLUE_BOLD}${reset_hms}${RESET})"
  fi
else
  five_bar=$(render_bar 0 "$bar_width" "$GRAY")
  five_str="${GRAY}5h ${WALL}${five_bar}${GRAY}${WALL}  --${RESET}"
fi

if [ "$have_seven" -eq 1 ]; then
  seven_color=$(pick_color "$seven_int")
  seven_bar=$(render_bar "$seven_int" "$bar_width" "$seven_color")
  seven_str=$(printf '7d %s%s%s %s%3d%%%s' "$WALL" "$seven_bar" "$WALL" "$seven_color" "$seven_int" "$RESET")
  if [ "$have_seven_reset" -eq 1 ]; then
    seven_str="${seven_str} (${BRIGHT_BLUE_BOLD}${seven_reset_hms}${RESET})"
  fi
else
  seven_bar=$(render_bar 0 "$bar_width" "$GRAY")
  seven_str="${GRAY}7d ${WALL}${seven_bar}${GRAY}${WALL}  --${RESET}"
fi

if [ "$have_ctx" -eq 1 ]; then
  ctx_color=$(pick_color "$ctx_int")
  ctx_bar=$(render_bar "$ctx_int" "$bar_width" "$ctx_color")
  ctx_str=$(printf 'ctx %s%s%s %s%3d%%%s' "$WALL" "$ctx_bar" "$WALL" "$ctx_color" "$ctx_int" "$RESET")
else
  ctx_bar=$(render_bar 0 "$bar_width" "$GRAY")
  ctx_str="${GRAY}ctx ${WALL}${ctx_bar}${GRAY}${WALL}  --${RESET}"
fi

if [ -n "$branch" ]; then
  branch_str="${YELLOW}${branch_text}${RESET}"
else
  branch_str="${GRAY}${branch_text}${RESET}"
fi

printf '%b │ %b │ %b │ %b │ %b\n' "$model_str" "$five_str" "$seven_str" "$ctx_str" "$branch_str"
