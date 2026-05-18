#!/usr/bin/env sh
set -eu

repo_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
profile="auto"
dry_run=0
force=0
check_only=0
install_deps=0
bootstrap_shell=0
set_shell=0
no_verify=0
stamp="$(date +%Y%m%d-%H%M%S)"

usage() {
  cat <<'EOF'
Usage: ./install.sh [auto|linux|macos] [options]

Profiles:
  auto     Detect Linux or macOS automatically.
  linux    Install Ubuntu/Linux-flavored config.
  macos    Install macOS-flavored config.

Options:
  --dry-run       Show what would change without writing files.
  --check         Check this machine without installing files.
  --install-deps  Install recommended dependencies, then continue.
  --bootstrap     Install Oh My Zsh, Powerlevel10k, and Zsh plugins.
  --set-shell     Set zsh as the default login shell after install.
  --no-verify     Skip repo syntax checks before installing.
  --force         Install even when required dependencies are missing.
EOF
}

log() {
  printf '%s\n' "$*"
}

section() {
  log ""
  log "==> $*"
}

warn() {
  printf 'warning: %s\n' "$*" >&2
}

run() {
  if [ "$dry_run" -eq 1 ]; then
    printf 'dry-run: %s\n' "$*"
  else
    "$@"
  fi
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

detect_profile() {
  if [ "$profile" = "auto" ]; then
    case "$(uname -s)" in
      Darwin) profile="macos" ;;
      Linux) profile="linux" ;;
      *)
        printf 'Unsupported OS: %s\n' "$(uname -s)" >&2
        printf 'Choose a profile explicitly: ./install.sh linux|macos\n' >&2
        exit 1
        ;;
    esac
  fi
}

recommended_packages() {
  case "$profile" in
    linux) printf '%s\n' 'zsh git curl eza zoxide fzf tmux gh' ;;
    macos) printf '%s\n' 'powerlevel10k zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search zoxide fzf lazygit eza' ;;
  esac
}

clone_or_update() {
  repo="$1"
  dest="$2"

  if [ -d "$dest/.git" ]; then
    log "updating $dest"
    run git -C "$dest" pull --ff-only
  elif [ -e "$dest" ]; then
    warn "$dest already exists and is not a git checkout; leaving it unchanged."
  else
    log "cloning $repo -> $dest"
    run git clone --depth=1 "$repo" "$dest"
  fi
}

dependency_hint() {
  case "$profile" in
    linux)
      if command_exists apt; then
        printf 'sudo apt update && sudo apt install -y %s\n' "$(recommended_packages)"
      elif command_exists dnf; then
        printf 'sudo dnf install -y %s\n' "$(recommended_packages)"
      elif command_exists pacman; then
        printf 'sudo pacman -S --needed %s\n' "$(recommended_packages)"
      else
        printf 'Install these packages with your package manager: %s\n' "$(recommended_packages)"
      fi
      ;;
    macos)
      if command_exists brew; then
        printf 'brew install %s\n' "$(recommended_packages)"
      else
        printf 'Install Homebrew first, then run: brew install %s\n' "$(recommended_packages)"
      fi
      ;;
  esac
}

install_dependencies() {
  section "Installing recommended dependencies"

  case "$profile" in
    linux)
      if command_exists apt; then
        run sudo apt update
        # shellcheck disable=SC2046
        run sudo apt install -y $(recommended_packages)
      elif command_exists dnf; then
        # shellcheck disable=SC2046
        run sudo dnf install -y $(recommended_packages)
      elif command_exists pacman; then
        # shellcheck disable=SC2046
        run sudo pacman -S --needed $(recommended_packages)
      else
        warn "No supported package manager found."
        dependency_hint
      fi
      ;;
    macos)
      if command_exists brew; then
        # shellcheck disable=SC2046
        run brew install $(recommended_packages)
      else
        warn "Homebrew is required for automatic macOS dependency installation."
        dependency_hint
      fi
      ;;
  esac
}

bootstrap_shell_tools() {
  section "Bootstrapping shell ecosystem"

  if ! command_exists git; then
    warn "git is required before shell tools can be bootstrapped."
    return 1
  fi

  case "$profile" in
    linux)
      clone_or_update "https://github.com/ohmyzsh/ohmyzsh.git" "$HOME/.oh-my-zsh"
      run mkdir -p "$HOME/.oh-my-zsh/custom/themes" "$HOME/.oh-my-zsh/custom/plugins"
      clone_or_update "https://github.com/romkatv/powerlevel10k.git" "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
      clone_or_update "https://github.com/zsh-users/zsh-autosuggestions.git" "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
      clone_or_update "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
      clone_or_update "https://github.com/zsh-users/zsh-history-substring-search.git" "$HOME/.oh-my-zsh/custom/plugins/history-substring-search"
      ;;
    macos)
      if ! command_exists brew; then
        warn "Homebrew is required for macOS shell bootstrap."
        dependency_hint
        return 0
      fi
      # shellcheck disable=SC2046
      run brew install $(recommended_packages)
      ;;
  esac
}

set_default_shell() {
  section "Setting default shell"

  if ! command_exists zsh; then
    warn "zsh is not available; default shell was not changed."
    return 0
  fi

  zsh_path="$(command -v zsh)"
  current_shell="${SHELL:-}"

  if [ "$current_shell" = "$zsh_path" ]; then
    log "Default shell already appears to be $zsh_path"
    return 0
  fi

  if command_exists chsh; then
    current_user="${USER:-$(id -un)}"
    run chsh -s "$zsh_path" "$current_user"
    log "Requested default shell: $zsh_path"
  else
    warn "chsh is not available; set your login shell manually to $zsh_path"
  fi
}

check_dependencies() {
  section "Checking dependencies"

  missing_required=''
  for cmd in zsh git; do
    if ! command_exists "$cmd"; then
      missing_required="$missing_required $cmd"
    fi
  done

  missing_optional=''
  for cmd in eza zoxide fzf; do
    if ! command_exists "$cmd"; then
      missing_optional="$missing_optional $cmd"
    fi
  done

  if [ "$profile" = "macos" ] && ! command_exists brew; then
    missing_optional="$missing_optional brew"
  fi

  if [ "$profile" = "linux" ]; then
    [ -r "$HOME/.oh-my-zsh/oh-my-zsh.sh" ] || missing_optional="$missing_optional oh-my-zsh"
    [ -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ] || missing_optional="$missing_optional powerlevel10k"
    [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ] || missing_optional="$missing_optional zsh-autosuggestions"
    [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ] || missing_optional="$missing_optional zsh-syntax-highlighting"
    [ -d "$HOME/.oh-my-zsh/custom/plugins/history-substring-search" ] || missing_optional="$missing_optional history-substring-search"
  fi

  if [ -n "$missing_required" ]; then
    printf 'missing required commands:%s\n' "$missing_required" >&2
    printf 'Suggested install command:\n  %s\n' "$(dependency_hint)" >&2
    if [ "$force" -ne 1 ]; then
      printf 'Rerun with --install-deps to install them automatically, or --force to continue anyway.\n' >&2
      exit 1
    fi
  fi

  if [ -n "$missing_optional" ]; then
    warn "missing optional commands:$missing_optional"
    printf 'Suggested install command:\n  %s\n' "$(dependency_hint)"
    if [ "$profile" = "linux" ]; then
      printf 'Suggested shell bootstrap:\n  ./install.sh --bootstrap\n'
    fi
  else
    log "All recommended commands are available."
  fi
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    auto|linux|macos) profile="$1" ;;
    --dry-run) dry_run=1 ;;
    --check) check_only=1 ;;
    --install-deps) install_deps=1 ;;
    --bootstrap) bootstrap_shell=1 ;;
    --set-shell) set_shell=1 ;;
    --no-verify) no_verify=1 ;;
    --force) force=1 ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
  esac
  shift
done

detect_profile

section "customizecmd installer"
log "Profile: $profile"

if [ "$install_deps" -eq 1 ]; then
  install_dependencies
fi

if [ "$bootstrap_shell" -eq 1 ]; then
  bootstrap_shell_tools
fi

check_dependencies

if [ "$check_only" -eq 1 ]; then
  log ""
  log "Check complete. No files were changed."
  exit 0
fi

if [ "$no_verify" -ne 1 ]; then
  section "Verifying repo files"
  if [ -x "$repo_dir/verify.sh" ]; then
    "$repo_dir/verify.sh"
  else
    sh "$repo_dir/verify.sh"
  fi
fi

backup_and_copy() {
  src="$1"
  dest="$2"

  if [ -f "$dest" ] && cmp -s "$src" "$dest"; then
    log "unchanged $dest"
    return 0
  fi

  if [ -f "$dest" ]; then
    run cp "$dest" "$dest.backup.$stamp"
  fi

  run mkdir -p "$(dirname -- "$dest")"
  run cp "$src" "$dest"
  if [ "$dry_run" -eq 1 ]; then
    log "would install $dest from $(basename -- "$src")"
  else
    log "installed $dest from $(basename -- "$src")"
  fi
}

section "Installing shell files"
backup_and_copy "$repo_dir/zshrc.$profile" "$HOME/.zshrc"
backup_and_copy "$repo_dir/p10k.$profile.zsh" "$HOME/.p10k.zsh"
backup_and_copy "$repo_dir/gitconfig.$profile" "$HOME/.gitconfig"

run mkdir -p "$HOME/.config/customizecmd"
for file in "$repo_dir"/shell/*.zsh; do
  target="$HOME/.config/customizecmd/$(basename -- "$file")"
  if [ -f "$target" ] && cmp -s "$file" "$target"; then
    log "unchanged $target"
  else
    run cp "$file" "$target"
    if [ "$dry_run" -eq 1 ]; then
      log "would install $target"
    else
      log "installed $target"
    fi
  fi
done

section "Post-install check"
if [ "$dry_run" -eq 1 ]; then
  log "dry-run: zsh -n $HOME/.zshrc"
elif command_exists zsh; then
  zsh -n "$HOME/.zshrc"
  log "zsh syntax ok"
else
  warn "zsh is not available; skipping installed ~/.zshrc syntax check."
fi

if [ "$set_shell" -eq 1 ]; then
  set_default_shell
fi

if [ "$dry_run" -eq 1 ]; then
  log ''
  log "Dry run complete for $profile profile. No files were changed."
else
  log ''
  log "Installed $profile profile."
  log 'Restart your terminal or run: source ~/.zshrc'
  log 'Run ./install.sh --check anytime to inspect this machine again.'
fi
