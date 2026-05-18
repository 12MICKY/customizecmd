#!/usr/bin/env sh
set -eu

zsh -n zshrc
zsh -n zshrc.linux
zsh -n zshrc.macos
zsh -n p10k.zsh
zsh -n p10k.linux.zsh
zsh -n p10k.macos.zsh
zsh -n shell/aliases.zsh
zsh -n shell/functions.zsh
sh -n install.sh
sh -n uninstall.sh

printf 'verify ok\n'
