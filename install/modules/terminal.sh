# Module: terminal -- ghostty.
# shellcheck shell=bash
install_packages "$PKG_DIR/terminal.list"

if require_command ghostty; then
  if ghostty +validate-config >/dev/null 2>&1; then
    log_ok "ghostty config valid"
  else
    log_warn "ghostty config could not be validated (config may not be stowed yet)"
  fi
fi
