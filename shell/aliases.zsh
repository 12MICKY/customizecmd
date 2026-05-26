# Navigation
alias c="clear"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias mkdirp="mkdir -p"
alias path='print -l $path'
alias h="history 1"
alias j="jobs -l"
alias reload="source ~/.zshrc"
alias zshconfig="$EDITOR ~/.zshrc"

# Directory listing
if command -v eza >/dev/null 2>&1; then
  alias ls="eza --icons --group-directories-first"
  alias ll="eza -lah --icons --group-directories-first --git"
  alias la="eza -la --icons --group-directories-first"
  alias tree="eza --tree --icons --group-directories-first"
else
  if [[ "$(uname -s)" == "Darwin" ]]; then
    alias ls="ls -G"
  fi
  alias ll="ls -lah"
  alias la="ls -la"
fi

# Git
alias gs="git status --short --branch"
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit"
alias gcm="git commit -m"
alias gca="git commit --amend"
alias gp="git push"
alias gpf="git push --force-with-lease"
alias gl="git pull --rebase --autostash"
alias gd="git diff"
alias gds="git diff --staged"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gb="git branch --sort=-committerdate"
alias glog="git log --oneline --decorate --graph --all -20"
unalias lg 2>/dev/null
command -v lazygit >/dev/null 2>&1 && alias lg="lazygit"

# Node
alias ni="npm install"
alias nr="npm run"
alias nd="npm run dev"
alias nb="npm run build"
unalias nt 2>/dev/null
alias ntest="npm test"
alias nx="npx"

# Python
alias py="python3"
alias venv="python3 -m venv .venv"
alias va="source .venv/bin/activate"
alias pipup="python3 -m pip install --upgrade pip"

# Docker
alias d="docker"
alias dc="docker compose"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcl="docker compose logs -f"
alias dps="docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
alias dex="docker exec -it"
alias dprune="docker system prune -af --volumes"

# System
alias now="date '+%Y-%m-%d %H:%M:%S %Z'"
alias dfh="df -h"
alias duh="du -sh * 2>/dev/null | sort -h"
alias topcpu="ps aux --sort=-%cpu | head -10"
alias topmem="ps aux --sort=-%mem | head -10"
unalias myip ip ipa 2>/dev/null

case "$(uname -s)" in
  Darwin)
    alias ports="lsof -nP -iTCP -sTCP:LISTEN"
    alias mem="top -l 1 -s 0 | grep PhysMem"
    alias update="brew update && brew upgrade"
    alias apt="brew"

    ipa() {
      ifconfig | grep "inet "
    }

    myip() {
      ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null
    }

    ip() {
      if [[ "$1" == "a" || "$1" == "addr" ]]; then
        ifconfig
      else
        ifconfig "$@"
      fi
    }
    ;;
  Linux)
    alias ports="ss -tulpn"
    alias myip="hostname -I | awk '{print \$1}'"
    alias mem="free -h"

    # Local app shortcuts
    unalias wine arduino 2>/dev/null
    [[ -x /usr/bin/wine ]] && alias wine="/usr/bin/wine"
    [[ -f "$HOME/Downloads/arduino-ide_2.3.8_Linux_64bit.AppImage" ]] && alias arduino="$HOME/Downloads/arduino-ide_2.3.8_Linux_64bit.AppImage --no-sandbox"
    ;;
esac
