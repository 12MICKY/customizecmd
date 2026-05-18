mkcd() {
  mkdir -p "$1" && cd "$1"
}

take() {
  mkcd "$1"
}

serve() {
  local port="${1:-8000}"
  python3 -m http.server "$port"
}

extract() {
  [[ -f "$1" ]] || { echo "extract: file not found: $1" >&2; return 1; }
  case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz)  tar xzf "$1" ;;
    *.tar.xz)  tar xJf "$1" ;;
    *.tar)     tar xf "$1" ;;
    *.tbz2)    tar xjf "$1" ;;
    *.tgz)     tar xzf "$1" ;;
    *.zip)     unzip "$1" ;;
    *.rar)     unrar x "$1" ;;
    *.7z)      7z x "$1" ;;
    *)         echo "extract: unsupported archive: $1" >&2; return 1 ;;
  esac
}

[[ -r "$HOME/.config/network-tools/network-tools.zsh" ]] && source "$HOME/.config/network-tools/network-tools.zsh"
