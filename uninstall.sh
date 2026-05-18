#!/usr/bin/env sh
set -eu

dry_run=0
remove_config=0

usage() {
  cat <<'EOF'
Usage: ./uninstall.sh [options]

Options:
  --dry-run        Show what would be restored or removed.
  --remove-config  Remove ~/.config/customizecmd after restoring backups.
EOF
}

log() {
  printf '%s\n' "$*"
}

section() {
  log ""
  log "==> $*"
}

warn() {
  printf 'warning: %s\n' "$*" >&2
}

run() {
  if [ "$dry_run" -eq 1 ]; then
    printf 'dry-run: %s\n' "$*"
  else
    "$@"
  fi
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run) dry_run=1 ;;
    --remove-config) remove_config=1 ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
  esac
  shift
done

restore_latest_backup() {
  dest="$1"
  latest="$(ls -t "$dest".backup.* 2>/dev/null | head -n 1 || true)"

  if [ -z "$latest" ]; then
    log "no backup found for $dest"
    return 0
  fi

  if [ -f "$dest" ] && cmp -s "$latest" "$dest"; then
    log "unchanged $dest"
    return 0
  fi

  run cp "$latest" "$dest"
  if [ "$dry_run" -eq 1 ]; then
    log "would restore $dest from $latest"
  else
    log "restored $dest from $latest"
  fi
}

section "Restoring backups"
restore_latest_backup "$HOME/.zshrc"
restore_latest_backup "$HOME/.p10k.zsh"
restore_latest_backup "$HOME/.gitconfig"

if [ "$remove_config" -eq 1 ]; then
  section "Removing customizecmd config"
  if [ -d "$HOME/.config/customizecmd" ]; then
    run rm -rf "$HOME/.config/customizecmd"
    if [ "$dry_run" -eq 1 ]; then
      log "would remove $HOME/.config/customizecmd"
    else
      log "removed $HOME/.config/customizecmd"
    fi
  else
    log "no customizecmd config directory found"
  fi
fi

section "Post-restore check"
if [ "$dry_run" -eq 1 ]; then
  log "dry-run: zsh -n $HOME/.zshrc"
elif command -v zsh >/dev/null 2>&1 && [ -f "$HOME/.zshrc" ]; then
  zsh -n "$HOME/.zshrc"
  log "zsh syntax ok"
else
  warn "zsh or ~/.zshrc is not available; skipping syntax check."
fi

log ""
log "Done. Restart your terminal or run: source ~/.zshrc"
