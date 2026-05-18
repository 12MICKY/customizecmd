#!/usr/bin/env sh
set -eu

restore_latest_backup() {
  dest="$1"
  latest="$(ls -t "$dest".backup.* 2>/dev/null | head -n 1 || true)"

  if [ -z "$latest" ]; then
    printf 'no backup found for %s\n' "$dest"
    return 0
  fi

  cp "$latest" "$dest"
  printf 'restored %s from %s\n' "$dest" "$latest"
}

restore_latest_backup "$HOME/.zshrc"
restore_latest_backup "$HOME/.p10k.zsh"
restore_latest_backup "$HOME/.gitconfig"

printf '\nDone. Restart your terminal or run: source ~/.zshrc\n'
