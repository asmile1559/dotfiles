# Module: fonts -- Maple Mono / Noto / Fira Code fonts and Bibata cursor.
# shellcheck shell=bash
install_packages "$PKG_DIR/fonts.list"

if (( DRY_RUN )); then
  log_dry "fc-cache -fv"
else
  if fc-cache -fv >/dev/null 2>&1; then
    log_ok "font cache rebuilt"
  else
    log_warn "fc-cache failed; run 'fc-cache -fv' manually"
  fi
fi
