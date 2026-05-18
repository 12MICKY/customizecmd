#!/usr/bin/env sh
set -eu

repo_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
stamp="$(date +%Y%m%d-%H%M%S)"
dry_run=0
force=0

usage() {
  cat <<'EOF'
Usage: ./install.sh [--dry-run] [--force]

Options:
  --dry-run  Show what would change without writing files.
  --force    Install even when optional dependencies are missing.
EOF
}

log() {
  printf '%s\n' "$*"
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
    --force) force=1 ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
  esac
  shift
done

missing=''
for cmd in zsh git; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    missing="$missing $cmd"
  fi
done

if [ -n "$missing" ] && [ "$force" -ne 1 ]; then
  printf 'missing required commands:%s\n' "$missing" >&2
  printf 'Install them first or rerun with --force.\n' >&2
  exit 1
fi

backup_and_copy() {
  src="$1"
  dest="$2"

  if [ -f "$dest" ]; then
    run cp "$dest" "$dest.backup.$stamp"
  fi

  run mkdir -p "$(dirname -- "$dest")"
  run cp "$src" "$dest"
  log "installed $dest"
}

backup_and_copy "$repo_dir/zshrc" "$HOME/.zshrc"
backup_and_copy "$repo_dir/p10k.zsh" "$HOME/.p10k.zsh"
backup_and_copy "$repo_dir/gitconfig" "$HOME/.gitconfig"

run mkdir -p "$HOME/.config/customizecmd"
for file in "$repo_dir"/shell/*.zsh; do
  run cp "$file" "$HOME/.config/customizecmd/$(basename -- "$file")"
  log "installed $HOME/.config/customizecmd/$(basename -- "$file")"
done

if [ "$dry_run" -eq 1 ]; then
  log ''
  log 'Dry run complete. No files were changed.'
else
  log ''
  log 'Done. Restart your terminal or run: source ~/.zshrc'
fi
