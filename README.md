# customizecmd

Minimal Zsh setup for daily development with separate macOS and Linux profiles.

## Includes

- Oh My Zsh + Powerlevel10k config
- macOS-style Powerlevel10k prompt with an Apple logo
- Ubuntu-style Linux prompt
- Useful dev aliases for Git, Node, Python, Homebrew/Linux package tooling, and system checks
- Better history, autosuggestions, and completion
- Optional fzf, zoxide, and lazygit integration

## Install

Auto-detect the OS:

```sh
./install.sh
```

Or choose explicitly:

```sh
./install.sh macos
./install.sh linux
```

The installer backs up existing files before replacing them.

## Recommended macOS packages

```sh
brew install powerlevel10k zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search zoxide fzf lazygit eza
```

## Files

- `zshrc.macos`, `p10k.macos.zsh`, `gitconfig.macos`
- `zshrc.linux`, `p10k.linux.zsh`, `gitconfig.linux`
