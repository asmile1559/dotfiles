# Module: niri -- niri compositor stack (primary session).
# shellcheck shell=bash
install_packages "$PKG_DIR/niri.list"

if require_command niri; then
  if niri validate >/dev/null 2>&1; then
    log_ok "niri config valid"
  else
    die "niri config is invalid - run 'niri validate' for details"
  fi
fi

if [[ -f /usr/share/wayland-sessions/niri.desktop ]]; then
  log_ok "niri session registered with the display manager"
else
  log_warn "niri Wayland session file is missing"
fi

log_info "the default login session is left unchanged; pick 'niri' at the login screen"
