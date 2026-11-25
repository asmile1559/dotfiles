# Module: dsh -- DeepSeek Harness web UI via npx (no AUR Electron package).
# shellcheck shell=bash
#
# The launcher is ~/.local/bin/dsh-web (stowed from .local/bin) and runs
# `npx --yes @deepseek-ai/dsh@next web`. This module only provides the
# Node.js/npx runtime, removes the old AUR package if it is still installed,
# and pre-fetches the CLI into the npx cache.
install_packages "$PKG_DIR/dsh.list"

# Replaced by the npx launcher; drop the AUR Electron build when present.
if pacman -Q deepseek-harness-desktop >/dev/null 2>&1; then
  log_info "removing the AUR deepseek-harness-desktop package (npx launcher replaces it)"
  if (( DRY_RUN )); then
    log_dry "pacman -Rns --noconfirm deepseek-harness-desktop"
  else
    sudo_run pacman -Rns --noconfirm deepseek-harness-desktop \
      || log_warn "failed to remove deepseek-harness-desktop; remove it manually with pacman -Rns"
  fi
else
  log_ok "AUR deepseek-harness-desktop is not installed"
fi

if ! require_command npx; then
  log_warn "npx is missing; install nodejs/npm before using ~/.local/bin/dsh-web"
  return 0
fi

log_info "pre-fetching @deepseek-ai/dsh into the npx cache"
if (( DRY_RUN )); then
  log_dry "npx --yes @deepseek-ai/dsh@next --version"
else
  npx --yes @deepseek-ai/dsh@next --version >/dev/null 2>&1 \
    || log_warn "could not pre-fetch @deepseek-ai/dsh; the first dsh-web launch will download it"
fi
