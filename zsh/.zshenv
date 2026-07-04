# Ensure a UTF-8 locale is set. Without one, LC_CTYPE falls back to POSIX/C and
# tmux runs in non-UTF-8 mode, rendering every non-ASCII character as a bare "_".
# Only act when no locale is configured, so machines that already set LANG
# (e.g. macOS Terminal) are left untouched. Prefer C.UTF-8, fall back to en_US.
if [[ -z "$LANG" && -z "$LC_ALL" && -z "$LC_CTYPE" ]]; then
  if locale -a 2>/dev/null | grep -qiE '^(C\.UTF-?8)$'; then
    export LANG=C.UTF-8
  elif locale -a 2>/dev/null | grep -qiE '^(en_US\.UTF-?8)$'; then
    export LANG=en_US.UTF-8
  fi
fi
