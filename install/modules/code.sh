# Module: code -- link VS Code user config without stowing the whole config dir.
# shellcheck shell=bash
#
# ~/.config/Code also holds machine-local state (caches, globalStorage, ...),
# so the config directory is deliberately NOT stowed (see .stow-local-ignore).
# Only the user config files below are symlinked into a real ~/.config/Code.
code_user_dir="$HOME/.config/Code/User"

for f in settings.json keybindings.json; do
  src="$REPO_DIR/.config/Code/User/$f"
  dst="$code_user_dir/$f"
  [[ -f "$src" ]] || continue

  if (( DRY_RUN )); then
    log_dry "install -d $code_user_dir"
    log_dry "ln -s $src $dst"
    continue
  fi

  install -d "$code_user_dir"

  if [[ -L "$dst" ]]; then
    rm -f "$dst"
  elif [[ -e "$dst" ]]; then
    mkdir -p "$BACKUP_DIR/.config/Code/User"
    mv -- "$dst" "$BACKUP_DIR/.config/Code/User/$f"
    log_info "backed up existing VS Code $f to $BACKUP_DIR/.config/Code/User/$f"
  fi

  ln -s "$src" "$dst"
  log_ok "linked VS Code config: $dst -> $src"
done
