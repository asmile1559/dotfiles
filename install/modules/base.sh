# Module: base -- system upgrade, archlinuxcn repo, core tools, AUR helper.
# shellcheck shell=bash
system_upgrade

ensure_archlinuxcn

install_packages "$PKG_DIR/base.list"

if (( SKIP_AUR )); then
  log_warn "AUR support disabled (--no-aur)"
else
  if ! find_aur_helper >/dev/null; then
    bootstrap_aur_helper
  fi
fi

if ! require_command stow; then
  die "stow is still missing after the base module"
fi
log_ok "core tooling ready: $(stow --version | head -n1)"
