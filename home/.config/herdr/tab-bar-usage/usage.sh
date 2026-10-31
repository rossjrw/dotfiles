#!/bin/sh
# Claude plan usage for herdr's tab bar. No network, no credentials: it only reuses the
# rate_limits that Claude Code already passes to the statusline script on stdin.
#
#   usage.sh write   statusline JSON on stdin -> cache  (called from ~/.claude/statusline.sh)
#   usage.sh show    cache -> one line for a ui.tab_bar_right command entry
#
# The limits are account-wide, so one cache file serves every Claude session.

state="${USAGE_STATE_DIR:-$HOME/.local/state/herdr-claude-usage}"
cache="$state/limits"   # "5h% 5h_reset 7d% 7d_reset updated" ("-" = absent), epoch seconds

write() {
  mkdir -p "$state"
  # Round in jq: shell printf %.0f breaks on "12.5" under a comma-decimal locale.
  set -- $(jq -r 'def pct: if . == null then "-" else round | tostring end;
    def ts: if . == null then "-" else floor | tostring end; [
    (.rate_limits.five_hour.used_percentage | pct),
    (.rate_limits.five_hour.resets_at | ts),
    (.rate_limits.seven_day.used_percentage | pct),
    (.rate_limits.seven_day.resets_at | ts)
  ] | join(" ")' 2>/dev/null)
  [ $# -eq 4 ] || exit 0
  # rate_limits is absent for non-subscribers and before a session's first API response.
  [ "$1" != "-" ] || [ "$3" != "-" ] || exit 0
  # Claude Code drops a window once its resets_at has passed; keep the cached one so the
  # reader can show it as reset (0%) instead of unknown.
  if [ -r "$cache" ] && read -r o5 or5 o7 or7 _ < "$cache"; then
    [ "$1" != "-" ] || { set -- "$o5" "$or5" "$3" "$4"; }
    [ "$3" != "-" ] || { set -- "$1" "$2" "$o7" "$or7"; }
  fi
  printf '%s %s %s %s %s\n' "$1" "$2" "$3" "$4" "$(date +%s)" > "$cache.tmp.$$" && mv "$cache.tmp.$$" "$cache"
}

# bar <pct> -> "━━────"
bar() {
  filled=$(( ($1 * 6 + 50) / 100 ))
  [ "$filled" -gt 6 ] && filled=6
  i=0 out=""
  while [ $i -lt 6 ]; do
    if [ $i -lt "$filled" ]; then out="${out}━"; else out="${out}─"; fi
    i=$((i + 1))
  done
  printf '%s' "$out"
}

# left <epoch> -> "2h13m" / "3d4h" / "12m"
left() {
  rem=$(( $1 - now ))
  [ "$rem" -lt 0 ] && rem=0
  if [ "$rem" -ge 86400 ]; then printf '%dd%dh' $((rem / 86400)) $(( (rem % 86400) / 3600 ))
  elif [ "$rem" -ge 3600 ]; then printf '%dh%dm' $((rem / 3600)) $(( (rem % 3600) / 60 ))
  else printf '%dm' $((rem / 60)); fi
}

# part <label> <pct|-> <reset|->
part() {
  label=$1 pct=$2 reset=$3
  [ "$pct" = "-" ] && { printf '%s ?' "$label"; return; }
  # Window already reset: usage is back to 0 until the next statusline update.
  if [ "$reset" != "-" ] && [ "$reset" -le "$now" ]; then pct=0 reset=-; fi
  printf '%s %s %d%%' "$label" "$(bar "$pct")" "$pct"
  [ "$reset" != "-" ] && printf ' %s' "$(left "$reset")"
}

show() {
  [ -r "$cache" ] || { echo "usage: waiting for a Claude statusline update"; exit 0; }
  read -r p5 r5 p7 r7 updated < "$cache"
  now=$(date +%s)
  line="$(part 5h "$p5" "$r5") | $(part 7d "$p7" "$r7")"
  # The numbers only change while a Claude session is active; say how old they are.
  age=$(( (now - updated) / 60 ))
  [ "$age" -ge 15 ] && line="$line (${age}m ago)"
  printf '%s\n' "$line"
}

case "${1:-show}" in
  write) write ;;
  show) show ;;
  *) echo "usage: $0 [write|show]" >&2; exit 2 ;;
esac
