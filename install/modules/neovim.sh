# Module: neovim -- LazyVim toolchain and plugin restore.
# shellcheck shell=bash
install_packages "$PKG_DIR/neovim.list"

if (( NO_NVIM_SYNC )); then
  log_warn "skipping Neovim plugin restore (--no-nvim-sync)"
elif require_command nvim; then
  log_info "restoring Neovim plugins from lazy-lock.json"
  if (( DRY_RUN )); then
    log_dry "nvim --headless '+Lazy! restore' +qa"
  else
    if ! timeout 900 nvim --headless "+Lazy! restore" +qa >/dev/null 2>&1; then
      log_warn "Neovim plugin restore failed; run ':Lazy restore' manually"
    fi
  fi
fi
