# install/modules —— 模块脚本

每个文件是一个模块，文件名（去掉 `.sh`）就是模块 id。`install.sh` 会按 profile 顺序
**source** 这些脚本，因此模块内不要写 shebang、不要 `set -e`、不要自己解析参数。

## 运行方式

```bash
# 按默认 profile 运行全部模块（GNOME + niri 一次装好）
install/install.sh

# 只跑某几个模块（忽略 profile 顺序，按给定的逗号顺序）
install/install.sh --only fonts,code

# 在默认基础上跳过某些模块
install/install.sh --skip flatpak,neovim

# 任何情况下都可以先预览
install/install.sh --dry-run --only niri
```

## 模块列表

| 模块 | 配置来源 | 主要动作 | 需要 root | 需要网络 | 需要 AUR |
| --- | --- | --- | --- | --- | --- |
| `base` | — | 系统升级、archlinuxcn 仓库、基础工具、AUR helper | 是 | 是 | 可能（引导 paru） |
| `stow` | 整个仓库 | 备份冲突文件、`stow .`、链接检查 | 否 | 否 | 否 |
| `shell` | shell.list | 装 zsh 生态、登录 shell、`zimfw install` | 是（chsh） | 是（zim 模块） | 是（zimfw） |
| `terminal` | terminal.list | 装 ghostty、校验配置 | 是 | 否 | 否 |
| `neovim` | neovim.list | 装工具链、`:Lazy restore` | 是 | 是（插件） | 否 |
| `fcitx5` | fcitx5.list | 装输入法与 Qt/Wayland 支持 | 是 | 否 | 否 |
| `fonts` | fonts.list | 装字体/光标、`fc-cache` | 是 | 否 | 是（Bibata） |
| `gnome` | gnome.list | 装 GDM/扩展、启用扩展与 pppd | 是 | 是（AUR 扩展） | 是（2 个扩展） |
| `niri` | niri.list | 装 niri 栈、`niri validate` | 是 | 否 | 否 |
| `dms` | dms.list | 装 Dux Modular Shell 与可选依赖、`dms doctor` | 是 | 否 | 否 |
| `apps` | apps.list | VS Code / Chrome / Timeshift | 是 | 是 | 是 |
| `dsh` | dsh.list | 装 Node.js/npx、预热 `@deepseek-ai/dsh`、移除旧 AUR Electron 包 | 是（移除时） | 是 | 否 |
| `code` | `.config/Code/User/` | 把 VS Code 用户配置软链进真实目录 | 否 | 否 | 否 |
| `flatpak` | flatpak.list | 装 flatpak、flathub 源、Flatseal | 是 | 是 | 否 |

> 完整的作用说明见 [../README.md](../README.md)；每个模块的包清单见
> [../packages/README.md](../packages/README.md)。

## 新增一个模块

1. 新建 `modules/<id>.sh`，结构参考：

   ```bash
   # Module: <id> -- 一句话说明。
   # shellcheck shell=bash
   install_packages "$PKG_DIR/<id>.list"
   ```

2. 需要包清单时，在 `packages/` 新建 `<id>.list`（格式见
   [../packages/README.md](../packages/README.md)），不需要就跳过第 1 步的
   `install_packages`。
3. 把 `<id>` 加到默认 profile `profiles/default.list` 中合适的位置
   （按依赖顺序，见 [../profiles/README.md](../profiles/README.md)）。
4. 同步文档：`install/README.md` 与 `install.sh --help` 里的模块列表。
5. 如需在最终校验中检查该模块，改 `install.sh` 的 `verify_installation()`：
   用 `module_ran <id>` 判断本次是否运行了该模块，再追加命令/链接/配置检查。

## 编写规范

- **幂等**：重复运行不报错；安装类操作用 `install_packages`（自带 `--needed`）。
- **dry-run 友好**：所有系统改动走 `sudo_run` / `run`，手动动作前用 `if (( DRY_RUN ))` 打印。
- **错误处理**：无法继续时 `die "..."`；可降级的问题用 `log_warn`。
- **只依赖公共函数**：[../lib/README.md](../lib/README.md) 里已有的 helper 能覆盖大部分场景，
  不要重复实现。
- **不要 `cd` 到仓库外**，不要写 `$HOME` 之外的数据；备份一律走 `$BACKUP_DIR`。
- 改完自检：

  ```bash
  shellcheck -x install/install.sh install/lib/common.sh install/modules/*.sh
  install/install.sh --dry-run --only <id>
  ```
