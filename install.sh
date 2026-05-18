#!/usr/bin/env sh
set -eu

stamp="$(date +%Y%m%d-%H%M%S)"

backup_and_copy() {
  src="$1"
  dest="$2"

  if [ -f "$dest" ]; then
    cp "$dest" "$dest.backup.$stamp"
  fi

  cp "$src" "$dest"
  printf 'installed %s\n' "$dest"
}

backup_and_copy "./zshrc" "$HOME/.zshrc"
backup_and_copy "./p10k.zsh" "$HOME/.p10k.zsh"
backup_and_copy "./gitconfig" "$HOME/.gitconfig"

printf '\nDone. Restart your terminal or run: source ~/.zshrc\n'

