# Module: shell -- zsh, zimfw modules, starship, direnv, zoxide, CLI helpers.
# shellcheck shell=bash
install_packages "$PKG_DIR/shell.list"

current_shell="$(getent passwd "$USER" | cut -d: -f7)"
if [[ "$current_shell" != "/usr/bin/zsh" ]]; then
  log_info "setting the login shell to zsh"
  sudo_run chsh -s /usr/bin/zsh "$USER" || log_warn "chsh failed; change the login shell manually"
fi

if [[ -f /usr/share/zimfw/zimfw.zsh ]]; then
  log_info "installing zsh modules with zimfw"
  if (( DRY_RUN )); then
    log_dry "zimfw install (modules -> ~/.config/zsh/.zim)"
  else
    if ! ZIM_HOME="$HOME/.config/zsh/.zim" ZIM_CONFIG_FILE="$HOME/.config/zsh/.zimrc" \
      zsh -c 'source /usr/share/zimfw/zimfw.zsh install'; then
      log_warn "zimfw install failed; modules will be fetched on the first interactive shell"
    fi
  fi
else
  log_warn "zimfw not found; zsh modules will install on the first interactive shell"
fi
