#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")"

profile="${1:-auto}"

if [ "$profile" = "auto" ]; then
  case "$(uname -s)" in
    Darwin) profile="macos" ;;
    Linux) profile="linux" ;;
    *)
      printf 'Unsupported OS: %s\n' "$(uname -s)" >&2
      printf 'Usage: %s [macos|linux]\n' "$0" >&2
      exit 1
      ;;
  esac
fi

case "$profile" in
  macos|linux) ;;
  *)
    printf 'Unknown profile: %s\n' "$profile" >&2
    printf 'Usage: %s [macos|linux]\n' "$0" >&2
    exit 1
    ;;
esac

stamp="$(date +%Y%m%d-%H%M%S)"

backup_and_copy() {
  src="$1"
  dest="$2"

  if [ -f "$dest" ]; then
    cp "$dest" "$dest.backup.$stamp"
  fi

  cp "$src" "$dest"
  printf 'installed %s from %s\n' "$dest" "$src"
}

backup_and_copy "./zshrc.$profile" "$HOME/.zshrc"
backup_and_copy "./p10k.$profile.zsh" "$HOME/.p10k.zsh"
backup_and_copy "./gitconfig.$profile" "$HOME/.gitconfig"

printf '\nInstalled %s profile.\n' "$profile"
printf 'Restart your terminal or run: source ~/.zshrc\n'
