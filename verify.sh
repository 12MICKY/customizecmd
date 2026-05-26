#!/usr/bin/env sh
set -eu

zsh -n zshrc
zsh -n zshrc.linux
zsh -n zshrc.linux-server
zsh -n zshrc.macos
zsh -n p10k.zsh
zsh -n p10k.linux.zsh
zsh -n p10k.linux-server.zsh
zsh -n p10k.macos.zsh
zsh -n shell/aliases.zsh
zsh -n shell/functions.zsh
sh -n install.sh
sh -n uninstall.sh

./install.sh --dry-run --no-verify >/dev/null 2>&1
./uninstall.sh --dry-run >/dev/null 2>&1

if command -v shellcheck >/dev/null 2>&1; then
  shellcheck install.sh uninstall.sh verify.sh
fi

printf 'verify ok\n'
