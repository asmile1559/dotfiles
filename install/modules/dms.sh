# Module: dms -- Dux Modular Shell (Quickshell, JSON config).
# shellcheck shell=bash
install_packages "$PKG_DIR/dms.list"

# Seed the session state once so the first login keeps the migrated wallpaper,
# Nanjing weather location and Chinese date/time locale. DMS rewrites this file
# afterwards; it is intentionally not tracked by stow.
dms_session="${XDG_STATE_HOME:-$HOME/.local/state}/dms/session.json"
dms_session_template="$REPO_DIR/install/templates/dms-session.json"
if [[ ! -f "$dms_session" && -f "$dms_session_template" ]]; then
  if (( DRY_RUN )); then
    log_dry "seed $dms_session from $dms_session_template"
  else
    mkdir -p "$(dirname -- "$dms_session")"
    sed "s|@HOME@|$HOME|g" "$dms_session_template" >"$dms_session"
    log_ok "seeded DMS session state: $dms_session"
  fi
fi

# 蓝牙：启用服务，DMS 的蓝牙面板才有数据
enable_systemd_unit bluetooth.service
if require_command bluetoothctl; then
  if bluetoothctl show >/dev/null 2>&1; then
    log_ok "bluetooth controller ready"
  else
    log_warn "no bluetooth controller detected (check hardware/rfkill)"
  fi
fi

if require_command dms; then
  # 由 systemd 用户服务托管 shell（niri.service wants dms.service）。
  # 若在无图形会话的 TTY 里执行，这一步可能失败，登录后在桌面里再跑一次即可。
  if (( DRY_RUN )); then
    log_dry "dms systemd enable"
  elif dms systemd enable >/dev/null 2>&1; then
    log_ok "dms.service enabled for the niri session"
  else
    log_warn "could not enable dms.service; run 'dms systemd enable' after logging in"
  fi

  log_info "dms: $(dms version 2>/dev/null | head -n1)"
  if dms doctor >/dev/null 2>&1; then
    log_ok "dms doctor passed"
  else
    log_warn "dms doctor reported issues - run 'dms doctor' for details"
  fi
  log_info "control the shell at runtime with: dms ipc call <target> <function>"
else
  log_warn "dms binary not found after installation"
fi

if [[ -d "$HOME/.config/noctalia" ]]; then
  log_warn "legacy Noctalia config still present: ~/.config/noctalia (this repo no longer manages it)"
fi
