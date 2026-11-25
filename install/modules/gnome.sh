# Module: gnome -- GDM + GNOME Shell, extensions and power profiles (secondary session).
# shellcheck shell=bash
install_packages "$PKG_DIR/gnome.list"

enable_gnome_extensions \
  appindicatorsupport@rgcjonas.gmail.com \
  clipboard-indicator@tudmotu.com \
  dash-to-dock@micxgx.gmail.com \
  blur-my-shell@aunetx

enable_systemd_unit power-profiles-daemon.service

if pacman -Q tuned >/dev/null 2>&1; then
  log_warn "tuned is installed and conflicts with power-profiles-daemon; keep only one of them"
fi

if systemctl is-enabled gdm.service >/dev/null 2>&1; then
  log_ok "gdm is enabled"
else
  other_dm=0
  for dm in sddm lightdm ly greetd; do
    if systemctl is-enabled "$dm.service" >/dev/null 2>&1; then
      other_dm=1
      log_warn "display manager '$dm' is enabled; not touching the default display manager"
    fi
  done
  if (( ! other_dm )); then
    sudo_run systemctl enable gdm.service || log_warn "failed to enable gdm"
  fi
fi
