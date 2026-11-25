#!/usr/bin/env bash
# shellcheck shell=bash
# ---------------------------------------------------------------------------
# common.sh - shared helpers for the dotfiles installer.
#
# Sourced by install/install.sh. Module scripts are sourced afterwards and
# use the helpers below; they must stay idempotent and dry-run aware.
#
# style note: every conditional helper avoids the `(( x )) && cmd` idiom,
# because with `set -e` a false arithmetic test would abort the installer.
# ---------------------------------------------------------------------------

# Repository paths ----------------------------------------------------------
REPO_DIR="${REPO_DIR:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)}"
INSTALL_DIR="$REPO_DIR/install"
# shellcheck disable=SC2034  # used by install.sh and modules/*.sh
PKG_DIR="$INSTALL_DIR/packages"
# shellcheck disable=SC2034  # used by install.sh and modules/*.sh
MODULE_DIR="$INSTALL_DIR/modules"
# shellcheck disable=SC2034  # used by install.sh and modules/*.sh
PROFILE_DIR="$INSTALL_DIR/profiles"

# Runtime options (set by install.sh before any module runs) ----------------
DRY_RUN="${DRY_RUN:-0}"
ASSUME_YES="${ASSUME_YES:-0}"
SKIP_AUR="${SKIP_AUR:-0}"
SKIP_FLATPAK="${SKIP_FLATPAK:-0}"
NO_UPGRADE="${NO_UPGRADE:-0}"
NO_NVIM_SYNC="${NO_NVIM_SYNC:-0}"
SUDO_CMD="${SUDO_CMD:-sudo}"
BACKUP_DIR="${BACKUP_DIR:-$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)}"
ARCHLINUXCN_SERVER="${ARCHLINUXCN_SERVER:-https://mirrors.aliyun.com/archlinuxcn/\$arch}"

# Colors --------------------------------------------------------------------
if [[ -t 1 ]]; then
  C_RESET=$'\033[0m'
  C_BOLD=$'\033[1m'
  C_DIM=$'\033[2m'
  C_RED=$'\033[31m'
  C_GREEN=$'\033[32m'
  C_YELLOW=$'\033[33m'
  C_BLUE=$'\033[34m'
else
  C_RESET=''
  C_BOLD=''
  C_DIM=''
  C_RED=''
  C_GREEN=''
  C_YELLOW=''
  C_BLUE=''
fi

# Logging -------------------------------------------------------------------
log_info() { printf '%s[%s]%s %s\n' "$C_DIM" "$(date +%H:%M:%S)" "$C_RESET" "$*"; }
log_step() { printf '\n%s==>%s %s%s%s\n' "$C_BLUE" "$C_RESET" "$C_BOLD" "$*" "$C_RESET"; }
log_ok()   { printf '%s  ok%s %s\n' "$C_GREEN" "$C_RESET" "$*"; }
log_warn() { printf '%swarn%s %s\n' "$C_YELLOW" "$C_RESET" "$*" >&2; }
log_dry()  { printf '%s  dry%s %s\n' "$C_YELLOW" "$C_RESET" "$*"; }
die()      { printf '%serror%s %s\n' "$C_RED" "$C_RESET" "$*" >&2; exit 1; }

# Command wrappers ----------------------------------------------------------
run() {
  if (( DRY_RUN )); then log_dry "$*"; return 0; fi
  "$@"
}

sudo_run() {
  if (( DRY_RUN )); then log_dry "$SUDO_CMD $*"; return 0; fi
  "$SUDO_CMD" "$@"
}

confirm() {
  local prompt="$1" reply=''
  (( ASSUME_YES )) && return 0
  [[ -t 0 ]] || die "stdin is not a terminal; re-run with --yes for non-interactive use"
  read -r -p "$prompt [y/N] " reply || true
  [[ "$reply" =~ ^[Yy]$ ]]
}

trim() {
  local s="$1"
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"
  printf '%s' "$s"
}

# Reading package lists -----------------------------------------------------
# Prints one package name per line, stripping comments and whitespace.
read_list() {
  local file="$1" line
  [[ -f "$file" ]] || return 0
  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%%#*}"
    line="${line//[[:space:]]/}"
    if [[ -n "$line" ]]; then
      printf '%s\n' "$line"
    fi
  done < "$file"
}

pkg_available() { pacman -Si -- "$1" >/dev/null 2>&1; }

# Package installation ------------------------------------------------------
_install_repo() {
  local -a pkgs=("$@")
  (( ${#pkgs[@]} > 0 )) || return 0
  log_info "pacman: ${pkgs[*]}"
  if (( DRY_RUN )); then
    log_dry "pacman -S --needed --noconfirm ${pkgs[*]}"
    return 0
  fi
  sudo_run pacman -S --needed --noconfirm -- "${pkgs[@]}"
}

_install_aur_if_any() {
  local -a pkgs=("$@")
  (( ${#pkgs[@]} > 0 )) || return 0
  if (( SKIP_AUR )); then
    log_warn "skipping AUR package(s) because --no-aur: ${pkgs[*]}"
    return 0
  fi
  install_aur "${pkgs[@]}"
}

# install_packages <file> - classify every entry as repo or AUR, then install.
install_packages() {
  local file="$1" p
  local -a repo_pkgs=() aur_pkgs=()
  while IFS= read -r p; do
    if pkg_available "$p"; then
      repo_pkgs+=("$p")
    else
      aur_pkgs+=("$p")
    fi
  done < <(read_list "$file")
  _install_repo "${repo_pkgs[@]}"
  _install_aur_if_any "${aur_pkgs[@]}"
}

# install_packages_direct <pkg>... - same as above but from arguments.
install_packages_direct() {
  local p
  local -a repo_pkgs=() aur_pkgs=()
  for p in "$@"; do
    if pkg_available "$p"; then
      repo_pkgs+=("$p")
    else
      aur_pkgs+=("$p")
    fi
  done
  _install_repo "${repo_pkgs[@]}"
  _install_aur_if_any "${aur_pkgs[@]}"
}

# AUR -----------------------------------------------------------------------
find_aur_helper() {
  if command -v paru 2>/dev/null; then return 0; fi
  if command -v yay 2>/dev/null; then return 0; fi
  return 1
}

bootstrap_aur_helper() {
  log_info "no AUR helper found; installing paru-bin (prebuilt package)"
  if (( DRY_RUN )); then
    log_dry "git clone https://aur.archlinux.org/paru-bin.git && makepkg -si"
    return 0
  fi
  command -v git >/dev/null 2>&1 || die "git is required to bootstrap paru"
  local tmp
  tmp="$(mktemp -d)"
  git clone --depth 1 https://aur.archlinux.org/paru-bin.git "$tmp/paru-bin" \
    || die "failed to clone paru-bin"
  ( cd "$tmp/paru-bin" && makepkg -si --noconfirm ) \
    || die "failed to build/install paru-bin"
  rm -rf "$tmp"
}

install_aur() {
  local -a pkgs=("$@")
  (( ${#pkgs[@]} > 0 )) || return 0
  local helper=''
  helper="$(find_aur_helper)" || helper=''
  if [[ -z "$helper" ]]; then
    bootstrap_aur_helper
    helper="$(find_aur_helper)" || die "AUR helper still unavailable after bootstrap"
  fi
  log_info "AUR (${helper##*/}): ${pkgs[*]}"
  if (( DRY_RUN )); then
    log_dry "$helper -S --needed --noconfirm ${pkgs[*]}"
    return 0
  fi
  case "${helper##*/}" in
    paru)
      local -a extra=()
      # Honour --sudo so paru uses the same privilege command as the installer.
      if [[ "$SUDO_CMD" != "sudo" ]] && command -v "$SUDO_CMD" >/dev/null 2>&1; then
        extra=(--sudo "$(command -v "$SUDO_CMD")")
      fi
      "$helper" -S --needed --noconfirm --skipreview "${extra[@]}" "${pkgs[@]}"
      ;;
    *)
      "$helper" -S --needed --noconfirm "${pkgs[@]}"
      ;;
  esac
}

# System / repositories -----------------------------------------------------
ensure_archlinuxcn() {
  if grep -qE '^\[archlinuxcn\]' /etc/pacman.conf 2>/dev/null; then
    log_ok "archlinuxcn repository present"
    return 0
  fi
  log_info "adding [archlinuxcn] repository to /etc/pacman.conf"
  if (( DRY_RUN )); then
    log_dry "append [archlinuxcn] to /etc/pacman.conf"
    return 0
  fi
  local backup
  backup="/etc/pacman.conf.bak.$(date +%Y%m%d-%H%M%S)"
  sudo_run cp -a /etc/pacman.conf "$backup" || die "cannot back up /etc/pacman.conf"
  printf '\n[archlinuxcn]\nServer = %s\n' "$ARCHLINUXCN_SERVER" \
    | sudo_run tee -a /etc/pacman.conf >/dev/null \
    || die "cannot append [archlinuxcn] to /etc/pacman.conf"
  sudo_run pacman -Sy --noconfirm || die "pacman -Sy failed after adding archlinuxcn"
  if ! sudo_run pacman -S --needed --noconfirm archlinuxcn-keyring; then
    log_warn "archlinuxcn-keyring install failed; archlinuxcn packages may fail signature checks"
  fi
}

system_upgrade() {
  if (( NO_UPGRADE )); then
    log_info "refreshing package databases only (--no-upgrade)"
    sudo_run pacman -Sy --noconfirm
  else
    log_info "upgrading the system (pacman -Syu)"
    sudo_run pacman -Syu --noconfirm
  fi
}

# Stow ----------------------------------------------------------------------
# Files that stow would link into $HOME. Prefers git's view of the repo so
# gitignored runtime state (VS Code storage, zsh caches, ...) is never touched.
repo_files() {
  ( cd "$REPO_DIR" || return 1
    if git rev-parse --git-dir >/dev/null 2>&1; then
      git ls-files --cached --others --exclude-standard -z \
        | tr '\0' '\n' \
        | while IFS= read -r f; do
            case "$f" in
              install/*|.config/Code/*|README.md|LICENSE|.gitignore|.gitmodules|.stow-local-ignore) continue ;;
            esac
            printf '%s\n' "$f"
          done
    else
      find . -type f \
        ! -path './.git/*' \
        ! -path './install/*' \
        ! -path './.config/Code/*' \
        ! -name '.gitignore' \
        ! -name '.gitmodules' \
        ! -name '.stow-local-ignore' \
        ! -name 'README.md' \
        -printf '%P\n'
    fi
  )
}

backup_conflicts() {
  local rel target target_real moved=0
  local repo_real
  repo_real="$(readlink -f -- "$REPO_DIR")"
  while IFS= read -r rel; do
    target="$HOME/$rel"
    # Resolve what the target really points at. If that is inside the repo the
    # path is already provided through a stowed directory symlink - nothing to do.
    target_real="$(readlink -f -- "$target" 2>/dev/null || true)"
    if [[ -n "$target_real" && "$target_real" == "$repo_real"/* ]]; then
      continue
    fi
    if [[ -L "$target" ]]; then
      : # symlink pointing outside the repo: back it up
    elif [[ ! -e "$target" ]]; then
      continue
    elif [[ -d "$target" ]]; then
      continue
    fi
    if (( DRY_RUN )); then
      log_dry "back up $target -> $BACKUP_DIR/$rel"
    else
      mkdir -p "$BACKUP_DIR/$(dirname -- "$rel")"
      mv -- "$target" "$BACKUP_DIR/$rel"
    fi
    moved=$((moved + 1))
  done < <(repo_files)
  if (( moved > 0 )); then
    log_info "backed up $moved conflicting path(s) to $BACKUP_DIR"
  fi
}

stow_apply() {
  command -v stow >/dev/null 2>&1 || die "stow is not installed"
  backup_conflicts
  log_info "stow: $REPO_DIR -> $HOME"
  if (( DRY_RUN )); then
    log_dry "stow --target=$HOME ."
    return 0
  fi
  ( cd "$REPO_DIR" && stow --target="$HOME" . ) \
    || die "stow failed - resolve the conflicts reported above and re-run"
}

# A path is considered stowed when it resolves to the same real file as in the
# repo. This also covers the common case where a parent directory is the symlink
# (e.g. ~/.config/nvim -> repo/.config/nvim), so the leaf itself is not a link.
check_symlink() {
  local rel="$1"
  [[ -e "$HOME/$rel" || -L "$HOME/$rel" ]] || return 1
  [[ "$(readlink -f -- "$HOME/$rel")" == "$(readlink -f -- "$REPO_DIR/$rel")" ]]
}

# GNOME / services ----------------------------------------------------------
enable_gnome_extensions() {
  local -a uuids=("$@")
  (( ${#uuids[@]} > 0 )) || return 0
  if ! command -v gsettings >/dev/null 2>&1; then
    log_warn "gsettings not found; enable the extensions manually after login"
    return 0
  fi
  : "${DBUS_SESSION_BUS_ADDRESS:=unix:path=/run/user/$(id -u)/bus}"
  export DBUS_SESSION_BUS_ADDRESS
  local current raw
  current="$(gsettings get org.gnome.shell enabled-extensions 2>/dev/null || true)"
  [[ -n "$current" ]] || current='[]'
  raw="${current#*[}"
  raw="${raw%]}"
  raw="${raw//\'/}"
  raw="${raw// /}"
  local -a existing=() missing=() parts=()
  IFS=',' read -r -a parts <<< "$raw"
  local p u e found=0
  for p in "${parts[@]}"; do
    if [[ -n "$p" ]]; then
      existing+=("$p")
    fi
  done
  for u in "${uuids[@]}"; do
    found=0
    for e in "${existing[@]}"; do
      if [[ "$e" == "$u" ]]; then
        found=1
        break
      fi
    done
    if (( ! found )); then
      missing+=("$u")
    fi
  done
  if (( ${#missing[@]} == 0 )); then
    log_ok "GNOME extensions already enabled"
    return 0
  fi
  local -a final=("${existing[@]}" "${missing[@]}")
  local value='['
  for u in "${final[@]}"; do
    value+="'$u', "
  done
  value="${value%, }]"
  if (( DRY_RUN )); then
    log_dry "gsettings set org.gnome.shell enabled-extensions \"$value\""
    return 0
  fi
  if gsettings set org.gnome.shell enabled-extensions "$value" 2>/dev/null; then
    log_ok "enabled GNOME extension(s): ${missing[*]}"
  else
    log_warn "could not enable extensions now (no GNOME session?): ${missing[*]}"
  fi
}

enable_systemd_unit() {
  local unit="$1"
  if (( DRY_RUN )); then
    log_dry "systemctl enable --now $unit"
    return 0
  fi
  if sudo_run systemctl enable --now "$unit"; then
    log_ok "service enabled: $unit"
  else
    log_warn "failed to enable service: $unit"
  fi
}

# Flatpak -------------------------------------------------------------------
flatpak_setup() {
  if (( SKIP_FLATPAK )); then
    log_warn "skipping flatpak (--no-flatpak)"
    return 0
  fi
  log_info "ensuring the flathub remote is configured"
  if (( DRY_RUN )); then
    log_dry "flatpak remote-add --system --if-not-exists flathub <flathub.flatpakrepo>"
    return 0
  fi
  sudo_run flatpak remote-add --system --if-not-exists flathub \
    https://dl.flathub.org/repo/flathub.flatpakrepo \
    || log_warn "could not add the flathub remote"
}

flatpak_install_from() {
  local file="$1" app
  if (( SKIP_FLATPAK )); then
    return 0
  fi
  while IFS= read -r app; do
    if [[ -z "$app" ]]; then
      continue
    fi
    log_info "flatpak install: $app"
    if (( DRY_RUN )); then
      log_dry "flatpak install --system --noninteractive -y flathub $app"
      continue
    fi
    sudo_run flatpak install --system --noninteractive -y flathub "$app" \
      || die "flatpak install failed: $app"
  done < <(read_list "$file")
}

require_command() {
  command -v "$1" >/dev/null 2>&1
}
