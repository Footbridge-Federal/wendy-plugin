#!/bin/sh
# Wendy update check, run at session start (hooks/hooks.json).
#
# Quiet unless a newer Wendy exists. Then it tells the user (systemMessage)
# and Wendy (additionalContext) that /wendy:update installs it. It asks
# GitHub at most once every 6 hours (the answer is cached in the plugin's
# data directory) with a 3-second cap, and any failure is silent: a session
# start is never slowed down or broken by this.
[ "${WENDY:-}" = 1 ] || exit 0
root="${CLAUDE_PLUGIN_ROOT:-}"
[ -n "$root" ] || exit 0

# The first "version": "1.2.3" in a plugin.json (digits and dots only).
ver() { sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([0-9][0-9.]*\)".*/\1/p' | head -n 1; }

installed=$(ver < "$root/.claude-plugin/plugin.json" 2>/dev/null)
[ -n "$installed" ] || exit 0

data="${CLAUDE_PLUGIN_DATA:-$HOME/.claude/plugins/data/wendy-footbridge}"
cache="$data/latest-version"
now=$(date +%s)
latest=""
if [ -f "$cache" ]; then
  read -r stamp cached < "$cache" 2>/dev/null || true
  case "$stamp" in
    ''|*[!0-9]*) ;;
    *) if [ $((now - stamp)) -lt 21600 ]; then latest="$cached"; fi ;;
  esac
fi
if [ -z "$latest" ]; then
  url="https://raw.githubusercontent.com/Footbridge-Federal/wendy-plugin/main/plugins/wendy/.claude-plugin/plugin.json"
  latest=$(curl -fsS --max-time 3 "$url" 2>/dev/null | ver)
  [ -n "$latest" ] || exit 0
  mkdir -p "$data" 2>/dev/null && printf '%s %s\n' "$now" "$latest" > "$cache" 2>/dev/null
fi
case "$latest" in ''|*[!0-9.]*) exit 0 ;; esac

newer=$(awk -v a="$latest" -v b="$installed" 'BEGIN {
  n = split(a, x, "."); m = split(b, y, "."); k = (n > m) ? n : m
  for (i = 1; i <= k; i++) {
    if (x[i] + 0 > y[i] + 0) { print 1; exit }
    if (x[i] + 0 < y[i] + 0) { print 0; exit }
  }
  print 0
}')
[ "$newer" = 1 ] || exit 0

printf '{"systemMessage":"Wendy %s is available (you have %s). Run /wendy:update to install it.","hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"A Wendy plugin update is available (%s -> %s). Tell the user once, in one line, that /wendy:update installs it."}}\n' \
  "$latest" "$installed" "$installed" "$latest"
