#!/usr/bin/env bash
# ~/.config/statusline/statusline.sh
#
# Global terminal status line.
# Line 1: model + effort/thinking | session cost | context-window usage bar | git branch
# Line 2: 5-hour rate-limit usage bar | 7-day rate-limit usage bar
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

MIN_BAR=12
MAX_BAR=30

input=$(cat)

RESET=$'\033[0m'
GREEN=$'\033[1;92m'
YELLOW=$'\033[1;93m'
RED=$'\033[1;91m'
GRAY=$'\033[2;37m'
DIM_GRAY=$'\033[2;90m'
BRIGHT_BLUE_BOLD=$'\033[1;94m'
GOLD=$'\033[1;38;5;220m'
WALL='┃'

# Strips ANSI SGR codes so a colored string's true on-screen width can be measured.
strip_ansi() {
  printf '%s' "$1" | sed -E "s/$(printf '\033')\[[0-9;]*m//g"
}

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

# ---- active model (model.display_name) + reasoning effort (effort.level) ----
model_name=$(printf '%s' "$input" | jq -r '.model.display_name // .model.id // empty')
effort_level=$(printf '%s' "$input" | jq -r '.effort.level // empty')
thinking_enabled=$(printf '%s' "$input" | jq -r '.thinking.enabled | if . == null then "" else tostring end')
thinking_glyph=""
case "$thinking_enabled" in
  true) thinking_glyph=" ✅" ;;
  false) thinking_glyph=" ❌" ;;
esac
effort_suffix=""
[ -n "$effort_level" ] && effort_suffix=" (${effort_level}${thinking_glyph})"
model_str="${BRIGHT_BLUE_BOLD}✦ ${model_name}${effort_suffix}${RESET}"

# ---- session cost (cost.total_cost_usd) ----
cost_raw=$(printf '%s' "$input" | jq -r '.cost.total_cost_usd // empty')
if [ -n "$cost_raw" ]; then
  cost_fmt=$(printf '%.2f' "$cost_raw" 2>/dev/null || echo "0.00")
  cost_visible="(\$${cost_fmt})"
  cost_str="${GOLD}${cost_visible}${RESET}"
else
  cost_visible="(--)"
  cost_str="${GRAY}${cost_visible}${RESET}"
fi

# ---- git branch (not provided directly in the payload; derive it) ----
cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // empty')
branch=""
if [ -n "$cwd" ] && git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
fi
branch_text="${branch:-no-git}"

# ---- solve line-2 bar width (5h / 7d) from remaining terminal space ----
# fixed chrome per segment: "5h ┃" + "┃ 100%" = 4 + 6 = 10
# fixed chrome per segment: "7d ┃" + "┃ 100%" = 4 + 6 = 10
line2_reserved=$((11 + 11 + 3 + reset_chrome + reset_chrome_seven))
line2_avail=$((term_width - line2_reserved))
bar_width=$((line2_avail / 2))
[ "$bar_width" -lt "$MIN_BAR" ] && bar_width=$MIN_BAR
[ "$bar_width" -gt "$MAX_BAR" ] && bar_width=$MAX_BAR

# ---- compose ----
if [ "$have_five" -eq 1 ]; then
  five_color=$(pick_color "$five_int")
  five_bar=$(render_bar "$five_int" "$bar_width" "$five_color")
  five_str=$(printf '5HR %s%s%s %s%3d%%%s' "$WALL" "$five_bar" "$WALL" "$five_color" "$five_int" "$RESET")
  if [ "$have_five_reset" -eq 1 ]; then
    five_str="${five_str} (${BRIGHT_BLUE_BOLD}${reset_hms}${RESET})"
  fi
else
  five_bar=$(render_bar 0 "$bar_width" "$GRAY")
  five_str="${GRAY}5HR ${WALL}${five_bar}${GRAY}${WALL}  --${RESET}"
fi

if [ "$have_seven" -eq 1 ]; then
  seven_color=$(pick_color "$seven_int")
  seven_bar=$(render_bar "$seven_int" "$bar_width" "$seven_color")
  seven_str=$(printf '7DY %s%s%s %s%3d%%%s' "$WALL" "$seven_bar" "$WALL" "$seven_color" "$seven_int" "$RESET")
  if [ "$have_seven_reset" -eq 1 ]; then
    seven_str="${seven_str} (${BRIGHT_BLUE_BOLD}${seven_reset_hms}${RESET})"
  fi
else
  seven_bar=$(render_bar 0 "$bar_width" "$GRAY")
  seven_str="${GRAY}7DY ${WALL}${seven_bar}${GRAY}${WALL}  --${RESET}"
fi

# ---- align line 1's ctx bar under line 2's 7d bar ----
# target_col: on-screen column (char count) where "7DY" begins on line 2, i.e. the
# full visible width of the "5HR ..." segment plus its trailing " │ " separator.
# "5HR "/"7DY "/"CTX " are all 4-char labels, so no manual fudge is needed here.
five_plain=$(strip_ansi "$five_str")
target_col=$((${#five_plain} + 3))

model_plain=$(strip_ansi "$model_str")
cost_plain=$(strip_ansi "$cost_str")
# visible width of "model │ cost │ " with normal (unpadded) separators
line1_prefix_len=$((${#model_plain} + 3 + ${#cost_plain} + 3))

# all padding goes after model/effort (none around cost) so a longer model name
# just eats into this slot naturally instead of cramping cost's spacing
pad_needed=$((target_col - line1_prefix_len - 1))
[ "$pad_needed" -lt 0 ] && pad_needed=0
pad1=$pad_needed
pad_before_cost=0
pad_after_cost=0
pad1_str=$(printf '%*s' "$pad1" '')
pad_before_cost_str=$(printf '%*s' "$pad_before_cost" '')
pad_after_cost_str=$(printf '%*s' "$pad_after_cost" '')

# ctx bar fills whatever space remains after its own column position
# fixed chrome: "CTX ┃" + "┃ 100%" = 5 + 6 = 11, plus " │ " sep and branch name
ctx_bar_width=$((term_width - target_col - 11 - 3 - ${#branch_text}))
[ "$ctx_bar_width" -lt "$MIN_BAR" ] && ctx_bar_width=$MIN_BAR
[ "$ctx_bar_width" -gt "$MAX_BAR" ] && ctx_bar_width=$MAX_BAR

if [ "$have_ctx" -eq 1 ]; then
  ctx_color=$(pick_color "$ctx_int")
  ctx_bar=$(render_bar "$ctx_int" "$ctx_bar_width" "$ctx_color")
  ctx_str=$(printf 'CTX %s%s%s %s%3d%%%s' "$WALL" "$ctx_bar" "$WALL" "$ctx_color" "$ctx_int" "$RESET")
else
  ctx_bar=$(render_bar 0 "$ctx_bar_width" "$GRAY")
  ctx_str="${GRAY}CTX ${WALL}${ctx_bar}${GRAY}${WALL}  --${RESET}"
fi

if [ -n "$branch" ]; then
  branch_str="${YELLOW}${branch_text}${RESET}"
else
  branch_str="${GRAY}${branch_text}${RESET}"
fi

printf '%b%s │ %s%b%s │ %b │ %b\n%b │ %b\n' "$model_str" "$pad1_str" "$pad_before_cost_str" "$cost_str" "$pad_after_cost_str" "$ctx_str" "$branch_str" "$five_str" "$seven_str"
