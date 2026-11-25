# Module: fcitx5 -- input method engine and Wayland integration.
# shellcheck shell=bash
install_packages "$PKG_DIR/fcitx5.list"

log_info "fcitx5 environment (environment.d) and autostart entries come from the stowed config"
log_info "log out and back in once so GTK_IM_MODULE/XMODIFIERS are picked up"
