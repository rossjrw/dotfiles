#!/bin/bash

# Installation: edit ~/.claude/settings.json and set:
#    statusLine.type: "command"
#    statusLine.command: "~/.claude/statusline.sh"

input=$(cat)

# Cache the account-wide rate limits for herdr's tab bar (backgrounded so it never delays the statusline)
[ -x "$HOME/.config/herdr/tab-bar-usage/usage.sh" ] && (printf '%s' "$input" | "$HOME/.config/herdr/tab-bar-usage/usage.sh" write &) >/dev/null 2>&1

get_model_name() { echo "$input" | jq -r '.model.display_name'; }
get_current_dir() { echo "$input" | jq -r '.workspace.current_dir'; }
get_cost() { echo "$input" | jq -r '.cost.total_cost_usd' | awk '{printf "%.2f", $1}'; }
get_context_used() { echo "$input" | jq -r '.context_window.used_percentage // empty'; }
get_effort() { echo "$input" | jq -r '.effort.level // empty'; }

# Autocompaction threshold (% of total context window where compaction triggers)
COMPACTION_THRESHOLD=80

# Rescale raw context percentage so the compaction threshold = 100%
rescale_context() {
    local raw=$1
    if [ -z "$raw" ]; then
        echo ""
        return
    fi
    local scaled=$(echo "scale=1; r=$raw * 100 / $COMPACTION_THRESHOLD; if (r > 100) 100 else r" | bc -l)
    echo "$scaled"
}


MODEL=$(get_model_name)
EFFORT=$(get_effort)
DIR=$(get_current_dir)
DIR=${DIR/#$HOME/\~}
COST=$(get_cost)
CONTEXT_RAW=$(get_context_used)
CONTEXT_USED=$(rescale_context "$CONTEXT_RAW")

# ANSI color codes
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
DIM='\033[2m'
RESET='\033[0m'

# Color text based on context usage level
color_by_usage() {
    local used=$1
    local text=$2
    local pct=$(printf "%.0f" "$used")
    if [ "$pct" -ge 80 ]; then
        echo "${RED}${text}${RESET}"
    elif [ "$pct" -ge 50 ]; then
        echo "${YELLOW}${text}${RESET}"
    else
        echo "${GREEN}${text}${RESET}"
    fi
}

# Build status line: model, context, cost, pwd
MODEL_LABEL="$MODEL"
[ -n "$EFFORT" ] && MODEL_LABEL="$MODEL: $EFFORT"
STATUS="${CYAN}[$MODEL_LABEL]${RESET}"

# Add context usage if available
if [ -n "$CONTEXT_USED" ]; then
    CONTEXT_DISPLAY=$(printf "%.1f%%" "$CONTEXT_USED")
    COLORED_PCT=$(color_by_usage "$CONTEXT_USED" "$CONTEXT_DISPLAY")
    STATUS="$STATUS ${DIM}|${RESET} ctx:$COLORED_PCT"
fi

STATUS="$STATUS ${DIM}|${RESET} ${GREEN}\$$COST${RESET} ${DIM}|${RESET} ${DIM}${DIR}${RESET}"

echo -e "$STATUS"
