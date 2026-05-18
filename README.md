# customizecmd

Minimal Zsh setup for daily development with separate Linux and macOS profiles.

This repo keeps the prompt clean while improving the parts you use all day:
history search, completion, Git shortcuts, project navigation, and sensible
developer defaults.

## Preview

- Ubuntu-orange Powerlevel10k prompt on Linux
- macOS-style Powerlevel10k prompt on macOS
- Clean right prompt: status, long command time, jobs, venv, time
- Compact time format: `HH:MM`
- Git status in the prompt without noisy language/runtime versions

## Includes

- `zshrc.linux`, `p10k.linux.zsh`, `gitconfig.linux`
- `zshrc.macos`, `p10k.macos.zsh`, `gitconfig.macos`
- `shell/aliases.zsh` - daily command shortcuts
- `shell/functions.zsh` - helpers such as `mkcd`, `take`, `serve`, and `extract`
- `install.sh` - profile-aware, backup-aware installer
- `uninstall.sh` - restore latest backups
- `verify.sh` - syntax checks for the repo

Legacy single-profile files are kept for compatibility:

- `zshrc`
- `p10k.zsh`
- `gitconfig`

## Install

Preview changes:

```sh
./install.sh --dry-run
```

Auto-detect Linux or macOS:

```sh
./install.sh
```

Choose explicitly:

```sh
./install.sh linux
./install.sh macos
```

The installer backs up existing files with a timestamp before replacing them.

## Update

```sh
git pull
./install.sh
```

## Roll Back

```sh
./uninstall.sh
```

This restores the newest backups for:

- `~/.zshrc`
- `~/.p10k.zsh`
- `~/.gitconfig`

## Recommended Linux Packages

```sh
sudo apt install zsh git eza zoxide fzf tmux gh
```

## Recommended macOS Packages

```sh
brew install powerlevel10k zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search zoxide fzf lazygit eza
```

Oh My Zsh, Powerlevel10k, `zsh-autosuggestions`, and `zsh-syntax-highlighting`
are expected to exist in the standard Oh My Zsh custom directories.

## Useful Shortcuts

- `gs` - short Git status
- `glog` - compact commit graph
- `gl` - pull with rebase and autostash
- `gpf` - push with force-with-lease
- `nd` - `npm run dev`
- `nb` - `npm run build`
- `venv` - create `.venv`
- `va` - activate `.venv`
- `ports` - show listening ports
- `take dir` - create and enter a directory
- `serve 8000` - start a local static file server

## Key Bindings

- `Ctrl+R` - search command history
- `Up/Down` - search matching history by current input
- `Ctrl+Left/Right` - move by word
- `Ctrl+Space` - accept autosuggestion

## Verify

```sh
./verify.sh
```
