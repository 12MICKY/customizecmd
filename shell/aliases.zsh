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
alias lg="lazygit"

# Node
alias ni="npm install"
alias nr="npm run"
alias nd="npm run dev"
alias nb="npm run build"
alias nt="npm test"
alias nx="npx"

# Python
alias py="python3"
alias venv="python3 -m venv .venv"
alias va="source .venv/bin/activate"
alias pipup="python3 -m pip install --upgrade pip"

# System
alias ports="ss -tulpn"
alias myip="hostname -I | awk '{print \$1}'"
alias now="date '+%Y-%m-%d %H:%M:%S %Z'"
alias dfh="df -h"
alias mem="free -h"

# Local app shortcuts
alias wine="/usr/bin/wine"
alias arduino="~/Downloads/arduino-ide_2.3.8_Linux_64bit.AppImage --no-sandbox"

