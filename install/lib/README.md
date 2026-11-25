# install/lib —— 公共函数库

`common.sh` 由 `install.sh` 通过 `source` 加载，为所有模块提供统一的日志、命令执行、
包安装、AUR、stow 备份、GNOME/flatpak 等工具函数。

**这个目录不直接运行。** 新增逻辑时优先在这里加 helper，而不是在 `install.sh` 或模块里重复实现。

## 文件

| 文件 | 说明 |
| --- | --- |
| `common.sh` | 全部公共函数与全局变量 |

## 全局变量

| 变量 | 说明 |
| --- | --- |
| `REPO_DIR` | 仓库根目录（自动推导） |
| `INSTALL_DIR` | `$REPO_DIR/install` |
| `PKG_DIR` | `$REPO_DIR/install/packages` |
| `MODULE_DIR` | `$REPO_DIR/install/modules` |
| `PROFILE_DIR` | `$REPO_DIR/install/profiles` |
| `DRY_RUN` | `1` 时只打印动作、不执行 |
| `ASSUME_YES` | `1` 时跳过确认 |
| `SKIP_AUR` / `SKIP_FLATPAK` | 跳过 AUR / flatpak |
| `NO_UPGRADE` | 跳过 `pacman -Syu` |
| `NO_NVIM_SYNC` | 跳过 Neovim 插件恢复 |
| `SUDO_CMD` | 提权命令，默认 `sudo` |
| `BACKUP_DIR` | 冲突文件备份目录（`~/.dotfiles-backup-<时间戳>`） |
| `ARCHLINUXCN_SERVER` | archlinuxcn 仓库地址，可用环境变量覆盖 |

## 函数

### 日志与交互

| 函数 | 说明 |
| --- | --- |
| `log_info` / `log_step` / `log_ok` / `log_warn` / `log_dry` | 分级日志 |
| `die` | 打印错误并 `exit 1` |
| `confirm "提示"` | 交互确认（`--yes` 或非 tty 时行为不同） |

### 执行

| 函数 | 说明 |
| --- | --- |
| `run <cmd...>` | 尊重 `--dry-run` 的执行 |
| `sudo_run <cmd...>` | 通过 `$SUDO_CMD` 提权执行 |
| `trim <字符串>` | 去掉首尾空白 |

### 包与 AUR

| 函数 | 说明 |
| --- | --- |
| `read_list <文件>` | 读取清单文件，去掉注释/空白/空行 |
| `pkg_available <包名>` | `pacman -Si` 判断是否在仓库中 |
| `install_packages <文件>` | 读取清单，自动分为仓库包/AUR 包并安装 |
| `install_packages_direct <包...>` | 同上，但包名由参数给出 |
| `find_aur_helper` | 返回 paru/yay 路径 |
| `bootstrap_aur_helper` | 无 helper 时用 `paru-bin` 引导安装 |
| `install_aur <包...>` | 用 AUR helper 安装（paru 会沿用 `--sudo`） |
| `ensure_archlinuxcn` | 缺失时添加 `[archlinuxcn]` 仓库并安装 keyring |
| `system_upgrade` | `pacman -Syu`；`--no-upgrade` 时只 `-Sy` |

### stow 与链接

| 函数 | 说明 |
| --- | --- |
| `repo_files` | 列出 stow 会处理的文件（按 git 视图，忽略被 gitignore 的运行时状态） |
| `backup_conflicts` | 把 `$HOME` 中已存在的冲突文件备份到 `$BACKUP_DIR` |
| `stow_apply` | 备份冲突后执行 `stow --target="$HOME" .` |
| `check_symlink <相对路径>` | 判断该路径最终是否指向仓库中的同一文件（兼容父目录是软链的情况） |

### GNOME / 服务 / flatpak

| 函数 | 说明 |
| --- | --- |
| `enable_gnome_extensions <uuid...>` | 合并写入 `org.gnome.shell enabled-extensions` |
| `enable_systemd_unit <unit>` | `systemctl enable --now` |
| `flatpak_setup` | 确保存在 flathub 源 |
| `flatpak_install_from <文件>` | 逐行安装 flatpak 应用 id |
| `require_command <cmd>` | 判断命令是否存在 |

## 新增函数约定

1. **必须 dry-run 友好**：改动系统的命令通过 `sudo_run` / `run`，打印用 `log_dry`。
2. **必须幂等**：重复执行不出错、不重复安装/追加。
3. **失败要明确**：无法继续时调用 `die`，带可操作的错误信息。
4. **避免 `(( x )) && cmd` 写法**：脚本启用了 `set -e`，条件为假会导致整个安装中断，
   请改用 `if (( x )); then ... fi`。
5. 改完运行：

   ```bash
   shellcheck -x install/install.sh install/lib/common.sh install/modules/*.sh
   ```
