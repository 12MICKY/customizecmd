# customizecmd

Zsh setup for daily development and server work. Three profiles: Linux desktop,
Linux server, and macOS. Each shares the same shell functions and aliases while
keeping a prompt style that fits the context.

## Profiles

| Profile | Use case | Prompt style |
|---|---|---|
| `linux` | Ubuntu desktop | Ubuntu icon, orange, context hidden when local |
| `linux-server` | Linux server / SSH | Server icon, teal, user@host always visible |
| `macos` | macOS | macOS-style, Homebrew tools |

## Prompt features

**linux-server**
- Left: ` user@host  ~/path  branch`
- Right: `✘ 1  5s  14:32` (errors + slow commands + time; right side hidden on success)
- Filler `─` connects left and right
- Context always visible — useful when jumping between machines

**linux (desktop)**
- Left: ` ~/path  branch`
- Right: `✔  5s  14:32`
- Context shown only on SSH or with privileges

## Install

New machine (full setup):

```sh
git clone https://github.com/12MICKY/customizecmd.git
cd customizecmd
./install.sh --install-deps --bootstrap --set-shell        # desktop
./install.sh linux-server --install-deps --bootstrap --set-shell  # server
```

Make shortcuts:

```sh
make install         # auto-detect linux or macos
make install-server  # linux-server profile
make install-full    # desktop with deps + bootstrap + set shell
```

Quick install (deps already present):

```sh
./install.sh              # auto-detect
./install.sh linux
./install.sh linux-server
./install.sh macos
```

Preview changes without writing anything:

```sh
./install.sh --dry-run
make dry-run
```

Check this machine:

```sh
./install.sh --check
make check
```

## Update

```sh
git pull && ./install.sh
```

## Roll back

```sh
./uninstall.sh               # restore latest backups
./uninstall.sh --remove-config  # also remove ~/.config/customizecmd
```

## Packages

**Linux** (`apt`):
```sh
sudo apt install zsh git curl eza zoxide fzf tmux gh
```

**macOS** (`brew`):
```sh
brew install powerlevel10k zsh-autosuggestions zsh-syntax-highlighting \
             zsh-history-substring-search zoxide fzf lazygit eza
```

Oh My Zsh, Powerlevel10k, and plugins are expected in the standard
`~/.oh-my-zsh/custom/` directories. Use `--bootstrap` to install them.

## Shell shortcuts

### Navigation
| Alias | Command |
|---|---|
| `c` | clear |
| `..` `...` | cd up 1/2 levels |
| `take <dir>` | mkdir + cd |
| `h` | full history |
| `reload` | source ~/.zshrc |

### Git
| Alias | Command |
|---|---|
| `gs` | git status --short --branch |
| `ga` / `gaa` | git add / add --all |
| `gcm "msg"` | git commit -m |
| `gp` / `gpf` | push / push --force-with-lease |
| `gl` | pull --rebase --autostash |
| `gd` / `gds` | diff / diff --staged |
| `gco` / `gcb` | checkout / checkout -b |
| `glog` | compact commit graph |
| `lg` | lazygit (if installed) |

### Docker
| Alias | Command |
|---|---|
| `dps` | docker ps (formatted) |
| `dcu` | docker compose up -d |
| `dcd` | docker compose down |
| `dcl` | docker compose logs -f |
| `dex <name>` | docker exec -it |
| `dprune` | remove all unused containers/images/volumes |
| `dlog <name>` | tail container logs |
| `dsh <name>` | shell into container |

### System
| Alias | Command |
|---|---|
| `ports` | listening ports (ss -tulpn) |
| `myip` | local IP |
| `now` | current datetime |
| `dfh` | df -h |
| `duh` | du -sh sorted |
| `mem` | free -h |
| `topcpu` | top 10 by CPU |
| `topmem` | top 10 by memory |

### Node
| Alias | Command |
|---|---|
| `ni` / `nr` | npm install / npm run |
| `nd` / `nb` | npm run dev / build |

### Python
| Alias | Command |
|---|---|
| `py` | python3 |
| `venv` | python3 -m venv .venv |
| `va` | source .venv/bin/activate |

### Functions
| Function | Usage |
|---|---|
| `mkcd <dir>` | mkdir + cd |
| `extract <file>` | unpack any archive |
| `serve [port]` | static file server (default 8000) |
| `port <num>` | what's using this port |
| `sshcp user@host` | ssh-copy-id shorthand |
| `certcheck host:port` | show TLS cert expiry |

## Key bindings

| Key | Action |
|---|---|
| `Ctrl+R` | fuzzy history search |
| `↑` / `↓` | history search by current input |
| `Ctrl+←/→` | move by word |
| `Ctrl+Space` | accept autosuggestion |

## Verify

```sh
./verify.sh
make verify
```
