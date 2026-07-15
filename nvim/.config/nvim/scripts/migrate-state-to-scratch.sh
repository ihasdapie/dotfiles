#!/usr/bin/env bash
# migrate-state-to-scratch.sh — carry nvim's slow-$HOME-resident state onto
# fast local disk.
#
# init.lua (step 0) and legacy.vim now point XDG_DATA_HOME/XDG_STATE_HOME
# (and undodir/viewdir) at /scratch, else /tmp, instead of the (often NFS,
# e.g. bean dev boxes — docs/decisions/0010-node-local-nvme-scratch.md)
# $HOME default. This script copies over whatever already accumulated at the
# old $HOME locations so nothing is lost: installed plugins/mason/venv
# (regenerable, just slow to rebuild) and persistent undo/view history (not
# regenerable).
#
# Safe to re-run — rsync, additive, never deletes the $HOME-side originals.
# Re-run after a cross-node reschedule if /scratch comes back empty (ADR 0010:
# scratch is node-local, warm across a same-node restart but cold after a
# node move).
#
#     ~/.config/nvim/scripts/migrate-state-to-scratch.sh

set -euo pipefail

log() { printf '\033[1;34m[nvim-scratch]\033[0m %s\n' "$*"; }

if [ -d /scratch ]; then
    ROOT=/scratch/nvim
elif [ -d /tmp ]; then
    ROOT=/tmp/nvim
else
    log "no /scratch or /tmp on this host — nothing to do"
    exit 0
fi

SHARE_DST="$ROOT/data/nvim"
STATE_DST="$ROOT/state/nvim"
mkdir -p "$SHARE_DST" "$STATE_DST/undo" "$STATE_DST/view"

sync_dir() {
    local src="$1" dst="$2"
    if [ -d "$src" ]; then
        log "syncing $src -> $dst"
        rsync -a "$src"/ "$dst"/
    else
        log "skip (no $src)"
    fi
}

sync_dir "$HOME/.local/share/nvim" "$SHARE_DST"
sync_dir "$HOME/.local/state/nvim" "$STATE_DST"
sync_dir "$HOME/.config/nvim/undo" "$STATE_DST/undo"
sync_dir "$HOME/.config/nvim/view" "$STATE_DST/view"

log "done. nvim will use $SHARE_DST and $STATE_DST from now on."
log "NFS-side originals were left in place — remove them by hand once you've confirmed nvim works."
