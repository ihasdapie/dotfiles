#!/usr/bin/env bash
# setup-python-provider.sh — create the nvim-only Python provider venv.
#
# nvim's python3 provider (needed by UltiSnips, and any plugin that does
# `if has('python3')`) requires the `pynvim` package importable from whatever
# interpreter `g:python3_host_prog` points at. Rather than pollute the system
# Python, we keep a dedicated, uv-managed venv that ONLY contains pynvim.
#
# init.lua sets:
#     vim.g.python3_host_prog = stdpath("data") .. "/venv/bin/python3"
# ...iff that file exists. This script creates exactly that venv. Re-run it any
# time (it's idempotent) to rebuild the provider, e.g. on a fresh machine:
#
#     ~/.config/nvim/scripts/setup-python-provider.sh
#     ~/.config/nvim/scripts/setup-python-provider.sh --force   # rebuild from scratch
#
# Requirements: uv (https://docs.astral.sh/uv/). If missing, this script
# installs it via Homebrew when available, else via the official installer.

set -euo pipefail

PYTHON_VERSION="3.12"        # interpreter uv provisions for the venv
VENV_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/venv"
FORCE=0
[ "${1:-}" = "--force" ] && FORCE=1

log() { printf '\033[1;34m[nvim-python]\033[0m %s\n' "$*"; }

ensure_uv() {
    if command -v uv >/dev/null 2>&1; then
        log "uv present: $(uv --version)"
        return
    fi
    log "uv not found — installing"
    if command -v brew >/dev/null 2>&1; then
        brew install uv
    else
        curl -LsSf https://astral.sh/uv/install.sh | sh
        # The installer drops uv in ~/.local/bin; make it visible to this run.
        export PATH="$HOME/.local/bin:$PATH"
    fi
    command -v uv >/dev/null 2>&1 || { echo "uv install failed" >&2; exit 1; }
    log "installed uv: $(uv --version)"
}

main() {
    ensure_uv

    if [ "$FORCE" = 1 ] && [ -d "$VENV_DIR" ]; then
        log "removing existing venv ($VENV_DIR)"
        rm -rf "$VENV_DIR"
    fi

    if [ ! -x "$VENV_DIR/bin/python3" ]; then
        log "creating venv at $VENV_DIR (python $PYTHON_VERSION)"
        mkdir -p "$(dirname "$VENV_DIR")"
        uv venv --python "$PYTHON_VERSION" "$VENV_DIR"
    else
        log "venv already exists at $VENV_DIR"
    fi

    log "installing/upgrading pynvim into the venv"
    VIRTUAL_ENV="$VENV_DIR" uv pip install --upgrade pynvim

    log "verifying pynvim import"
    "$VENV_DIR/bin/python3" -c "import pynvim; print('pynvim', pynvim.__version__)"

    log "done. nvim will use: $VENV_DIR/bin/python3"
    log "run ':checkhealth vim.provider' in nvim to confirm."
}

main "$@"
