#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# install.sh - install packages and apply these dotfiles on Arch Linux.
#
# Usage: install/install.sh [options]
# Run with --dry-run first. See install/README.md for details.
# ---------------------------------------------------------------------------
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source-path=SCRIPTDIR
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"

PROFILE="${PROFILE:-default}"
ONLY="${ONLY:-}"
SKIP="${SKIP:-}"
DO_VERIFY=1
RUN_MODULES=()

# Fail loudly with context instead of a bare exit code.
on_error() {
  local rc=$?
  printf '%serror%s command failed (exit %s): %s\n' "$C_RED" "$C_RESET" "$rc" "$BASH_COMMAND" >&2
  printf '       at %s:%s\n' "${BASH_SOURCE[1]:-install.sh}" "${BASH_LINENO[0]:-?}" >&2
  exit "$rc"
}
trap on_error ERR

usage() {
  cat <<'EOF'
Usage: install/install.sh [options]

Options:
  -p, --profile NAME   Module profile (default: default = everything)
      --only IDS       Run only these modules (comma separated)
      --skip IDS       Skip these modules (comma separated)
      --dry-run        Print actions without changing anything
  -y, --yes            Assume yes for all prompts (non-interactive)
      --no-upgrade     Skip the full system upgrade; only refresh databases
      --no-aur         Do not install AUR packages
      --no-flatpak     Do not install flatpak applications
      --no-nvim-sync   Skip restoring Neovim plugins from lazy-lock.json
      --no-verify      Skip the final verification step
      --sudo CMD       Command used for root operations (default: sudo)
  -h, --help           Show this help

Modules (run in this order by the default profile):
  base      system upgrade, archlinuxcn repo, core tools, AUR helper
  stow      back up conflicting files and link this repo into $HOME
  shell     zsh/zimfw/starship/direnv/zoxide/fzf/... + login shell
  terminal  ghostty
  neovim    neovim + formatters/LSP toolchain, restore plugins
  fcitx5    fcitx5 input method + Wayland input integration
  fonts     Maple Mono / Noto / Fira Code / Bibata cursor + font cache
  gnome     GDM, GNOME Shell add-ons, extensions, power profiles
  niri      niri compositor stack (screenshots, media, brightness, portals)
  dms       Dux Modular Shell (desktop shell + matugen/cava/qt6ct)
  apps      VS Code, Chrome, Timeshift
  dsh       DeepSeek Harness web UI via npx (no AUR Electron package)
  code      link VS Code user config (settings.json) into a real ~/.config/Code
  flatpak   Flatpak + Flatseal

Examples:
  install/install.sh --dry-run       # preview everything
  install/install.sh --yes           # install GNOME + niri + all tools
  install/install.sh --skip flatpak  # skip one module
  install/install.sh --only fonts,code
EOF
}

parse_args() {
  while (( $# > 0 )); do
    case "$1" in
      -p|--profile)   PROFILE="${2:?--profile requires a name}"; shift 2 ;;
      --profile=*)    PROFILE="${1#*=}"; shift ;;
      --only)         ONLY="${2:?--only requires module ids}"; shift 2 ;;
      --only=*)       ONLY="${1#*=}"; shift ;;
      --skip)         SKIP="${2:?--skip requires module ids}"; shift 2 ;;
      --skip=*)       SKIP="${1#*=}"; shift ;;
      --dry-run)      DRY_RUN=1; shift ;;
      -y|--yes)       ASSUME_YES=1; shift ;;
      --no-upgrade)   NO_UPGRADE=1; shift ;;
      --no-aur)       SKIP_AUR=1; shift ;;
      --no-flatpak)   SKIP_FLATPAK=1; shift ;;
      --no-nvim-sync) NO_NVIM_SYNC=1; shift ;;
      --no-verify)    DO_VERIFY=0; shift ;;
      --sudo)         SUDO_CMD="${2:?--sudo requires a command}"; shift 2 ;;
      --sudo=*)       SUDO_CMD="${1#*=}"; shift ;;
      -h|--help)      usage; exit 0 ;;
      *)              die "unknown option: $1 (try --help)" ;;
    esac
  done
}

preflight() {
  (( EUID != 0 )) || die "do not run this script as root - AUR helpers refuse to run as root"
  command -v pacman >/dev/null 2>&1 || die "pacman not found - this installer targets Arch Linux"
  if [[ ! -f /etc/arch-release ]]; then
    log_warn "not an Arch Linux system; pacman steps may fail"
  fi

  if (( DRY_RUN )); then
    log_info "dry-run: skipping sudo validation"
  else
    command -v "$SUDO_CMD" >/dev/null 2>&1 || die "sudo command not found: $SUDO_CMD"
    log_info "validating sudo: $SUDO_CMD -v"
    "$SUDO_CMD" -v || die "sudo validation failed ($SUDO_CMD -v)"
  fi

  if command -v curl >/dev/null 2>&1; then
    if ! curl -fsS --max-time 10 -o /dev/null https://archlinux.org 2>/dev/null \
      && ! curl -fsS --max-time 10 -o /dev/null https://geo.mirror.pkgbuild.com 2>/dev/null; then
      log_warn "network check failed: no route to archlinux.org / geo.mirror.pkgbuild.com"
    fi
  fi
}

profile_modules() {
  local profile="$1" file="$PROFILE_DIR/$1.list"
  if [[ ! -f "$file" ]]; then
    log_warn "unknown profile '$profile', falling back to 'default'"
    file="$PROFILE_DIR/default.list"
  fi
  read_list "$file"
}

# Fills SELECTED_MODULES (kept global so errors abort in the main shell).
select_modules() {
  SELECTED_MODULES=()
  local -a modules=() skip=()
  if [[ -n "$ONLY" ]]; then
    IFS=',' read -r -a modules <<< "$ONLY"
  else
    mapfile -t modules < <(profile_modules "$PROFILE")
  fi
  if [[ -n "$SKIP" ]]; then
    IFS=',' read -r -a skip <<< "$SKIP"
  fi

  local m s skipped
  for m in "${modules[@]}"; do
    m="$(trim "$m")"
    if [[ -z "$m" ]]; then
      continue
    fi
    skipped=0
    for s in "${skip[@]}"; do
      s="$(trim "$s")"
      if [[ "$s" == "$m" ]]; then
        skipped=1
        break
      fi
    done
    if (( skipped )); then
      continue
    fi
    [[ -f "$MODULE_DIR/$m.sh" ]] || die "unknown module: $m"
    SELECTED_MODULES+=("$m")
  done
  if (( ${#SELECTED_MODULES[@]} == 0 )); then
    die "no modules selected"
  fi
}

module_ran() {
  local want="$1" m
  for m in "${RUN_MODULES[@]}"; do
    if [[ "$m" == "$want" ]]; then
      return 0
    fi
  done
  return 1
}

verify_installation() {
  log_step "verifying installation"
  local -a failures=() cmds=() rels=()
  local cmd rel

  if module_ran shell; then cmds+=(zsh starship yazi); fi
  if module_ran terminal; then cmds+=(ghostty); fi
  if module_ran neovim; then cmds+=(nvim); fi
  if module_ran fcitx5; then cmds+=(fcitx5); fi
  if module_ran niri; then cmds+=(niri satty); fi
  if module_ran dms; then cmds+=(dms qs); fi
  if module_ran apps; then cmds+=(code google-chrome-stable timeshift); fi
  if module_ran dsh; then cmds+=(npx); fi
  if module_ran flatpak; then cmds+=(flatpak); fi
  if module_ran gnome; then cmds+=(powerprofilesctl extension-manager); fi

  for cmd in "${cmds[@]}"; do
    if require_command "$cmd"; then
      log_ok "command: $cmd"
    else
      log_warn "missing command: $cmd"
      failures+=("cmd:$cmd")
    fi
  done

  if module_ran stow; then
    rels+=(.zshenv .face)
    if module_ran shell; then rels+=(.config/zsh/.zshrc); fi
    if module_ran neovim; then rels+=(.config/nvim/init.lua); fi
    if module_ran terminal; then rels+=(.config/ghostty/config); fi
    if module_ran fcitx5; then rels+=(.config/fcitx5/config); fi
    if module_ran niri; then rels+=(.config/niri/config.kdl .config/satty/config.toml); fi
    if module_ran dms; then rels+=(.config/dms/settings.json); fi
    if module_ran dsh; then
      rels+=(.local/bin/dsh-web .local/share/applications/deepseek-ai-dsh.desktop
        .local/share/icons/hicolor/scalable/apps/deepseek-harness.svg)
    fi
    if module_ran code; then rels+=(.config/Code/User/settings.json); fi
    rels+=(.config/starship.toml)
    for rel in "${rels[@]}"; do
      if check_symlink "$rel"; then
        log_ok "linked: $rel"
      else
        log_warn "not linked: $rel"
        failures+=("link:$rel")
      fi
    done
  fi

  if module_ran niri && require_command niri; then
    if niri validate >/dev/null 2>&1; then
      log_ok "niri config valid"
    else
      log_warn "niri config invalid (run: niri validate)"
      failures+=("niri:config")
    fi
    if [[ -f /usr/share/wayland-sessions/niri.desktop ]]; then
      log_ok "niri session available"
    else
      log_warn "niri Wayland session file missing"
      failures+=("session:niri")
    fi
  fi

  if module_ran dms && require_command dms; then
    if dms doctor >/dev/null 2>&1; then
      log_ok "dms doctor passed"
    else
      log_warn "dms doctor reported issues (run: dms doctor)"
      failures+=("dms:doctor")
    fi
    if [[ -f "$HOME/.config/dms/settings.json" ]] \
      && command -v jq >/dev/null 2>&1 \
      && jq empty "$HOME/.config/dms/settings.json" >/dev/null 2>&1; then
      log_ok "dms settings.json valid"
    else
      log_warn "dms settings.json missing or invalid"
      failures+=("dms:settings")
    fi
  fi

  if module_ran terminal && require_command ghostty; then
    if ghostty +validate-config >/dev/null 2>&1; then
      log_ok "ghostty config valid"
    else
      log_warn "ghostty config invalid (run: ghostty +validate-config)"
      failures+=("ghostty:config")
    fi
  fi

  if module_ran gnome; then
    if systemctl is-enabled power-profiles-daemon >/dev/null 2>&1; then
      log_ok "power-profiles-daemon enabled"
    else
      log_warn "power-profiles-daemon is not enabled"
      failures+=("service:power-profiles-daemon")
    fi
  fi

  if module_ran flatpak; then
    if flatpak list --app --columns=application 2>/dev/null | grep -qx 'com.github.tchx84.Flatseal'; then
      log_ok "Flatseal installed"
    else
      log_warn "Flatseal is not installed"
      failures+=("flatpak:Flatseal")
    fi
  fi

  if module_ran dsh; then
    if pacman -Q deepseek-harness-desktop >/dev/null 2>&1; then
      log_warn "AUR deepseek-harness-desktop is still installed (npx launcher replaces it)"
      failures+=("aur:deepseek-harness-desktop")
    else
      log_ok "AUR deepseek-harness-desktop not installed"
    fi
  fi

  if (( ${#failures[@]} > 0 )); then
    log_warn "verification finished with ${#failures[@]} problem(s): ${failures[*]}"
    return 1
  fi
  log_ok "all checks passed"
}

main() {
  parse_args "$@"

  log_step "dotfiles installer"
  log_info "repo:    $REPO_DIR"
  log_info "profile: $PROFILE"
  if (( DRY_RUN )); then
    log_warn "dry-run mode: nothing will be changed"
  fi

  preflight

  SELECTED_MODULES=()
  select_modules
  local -a modules=("${SELECTED_MODULES[@]}")
  log_info "modules: ${modules[*]}"

  if (( ! DRY_RUN )) && (( ! ASSUME_YES )); then
    confirm "Proceed with ${#modules[@]} module(s)?" || die "aborted by user"
  fi

  RUN_MODULES=("${modules[@]}")
  local start=$SECONDS id
  for id in "${modules[@]}"; do
    log_step "module: $id"
    # shellcheck disable=SC1090
    source "$MODULE_DIR/$id.sh"
    log_ok "module '$id' done"
  done

  if (( DO_VERIFY )); then
    verify_installation
  fi

  log_step "done in $((SECONDS - start))s"
  if [[ -d "$BACKUP_DIR" ]]; then
    log_info "backups written to: $BACKUP_DIR"
  fi
  log_info "log out and back in (or reboot) to pick up session/IME changes."
}

main "$@"
