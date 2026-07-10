#!/usr/bin/env bash
# Pick a URL out of the current tmux pane and make it usable — even when it is a
# long PLAIN-TEXT link (e.g. a gcloud / bean auth URL) that tmux has soft-wrapped
# across several visual rows. The terminal can't mouse-detect such a wrapped URL
# because it only sees the rendered rows, so we rejoin them here instead.
#
# `capture-pane -J` un-wraps the pane back into logical lines; we grep the URLs,
# fzf-pick one, then land it on the *local* clipboard via OSC 52 (tmux set-buffer
# -w, which needs `set-clipboard on`). That works on a headless remote box with no
# browser — you just paste into your local browser. If a real opener exists (tmux
# running locally), open it directly too.
set -euo pipefail

pane="${1:-}"

url=$(
  tmux capture-pane -p -J -S -10000 ${pane:+-t "$pane"} \
    | grep -oE "https?://[^[:space:])>\"']+" \
    | awk '!seen[$0]++' \
    | fzf --no-sort --reverse --prompt 'url> '
) || exit 0
[ -n "$url" ] || exit 0

# OSC 52 -> outer terminal -> local clipboard.
tmux set-buffer -w -- "$url"

if command -v open >/dev/null 2>&1; then
  open "$url" >/dev/null 2>&1 || true
elif command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$url" >/dev/null 2>&1 || true
fi

tmux display-message "url copied to clipboard"
