# Module: stow -- back up conflicting files, then link this repo into $HOME.
# shellcheck shell=bash
stow_apply

for rel in .zshenv .face .config/nvim/init.lua .config/niri/config.kdl \
           .config/dms/settings.json .config/fcitx5/config \
           .config/ghostty/config .config/satty/config.toml \
           .config/starship.toml; do
  if check_symlink "$rel"; then
    log_ok "linked: $rel"
  else
    log_warn "not linked: $rel"
  fi
done
