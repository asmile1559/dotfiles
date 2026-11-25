# 自动安装脚本

`install/install.sh` 负责安装本 dotfiles 仓库所需的软件包，并用 GNU Stow 把仓库链接到
`$HOME`。脚本是幂等的：重复执行只会补齐缺失项；遇到已存在的真实文件会先备份，不会直接覆盖。

## 快速开始

```bash
git clone https://github.com/asmile1559/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 务必先预览
install/install.sh --dry-run

# 再一键安装：在 GNOME 基础上装好全部（含 niri 会话）
install/install.sh
```

前置要求：Arch Linux（通常在已安装好的 GNOME 系统上执行）、普通用户（**不要**用 root 运行）
且 `sudo` 可用、能访问网络。
`base` 模块会安装 `base-devel`、`git`、`stow`，在缺失时添加 `[archlinuxcn]` 仓库，
并在没有 AUR helper（`paru`/`yay`）时自动引导安装 `paru-bin`。

## 参数

| 参数 | 说明 |
| --- | --- |
| `-p, --profile NAME` | 模块 profile，默认 `default`（包含全部模块）；一般无需指定 |
| `--only IDS` | 只运行指定模块，逗号分隔 |
| `--skip IDS` | 跳过指定模块，逗号分隔 |
| `--dry-run` | 只打印将执行的动作，不改动系统 |
| `-y, --yes` | 非交互模式，跳过确认提示 |
| `--no-upgrade` | 跳过 `pacman -Syu`，只刷新数据库 |
| `--no-aur` | 不安装 AUR 包 |
| `--no-flatpak` | 不安装 flatpak 应用 |
| `--no-nvim-sync` | 跳过 Neovim 插件的 `:Lazy restore` |
| `--no-verify` | 跳过最终校验 |
| `--sudo CMD` | 指定提权命令（例如无密码包装脚本） |
| `-h, --help` | 显示帮助 |

## 模块

| 模块 | 作用 |
| --- | --- |
| `base` | 系统升级、archlinuxcn 仓库与 keyring、基础工具、AUR helper 引导 |
| `stow` | 把冲突文件备份到 `~/.dotfiles-backup-<时间戳>/`，执行 `stow .` |
| `shell` | zsh/zimfw/starship/direnv/zoxide/fzf/fd/rg/bat/eza、`yazi`、登录 shell、zimfw 模块 |
| `terminal` | ghostty |
| `neovim` | neovim + 格式化/LSP 工具链，按 `lazy-lock.json` 执行 `:Lazy restore` |
| `fcitx5` | fcitx5 + 中文输入法组件 + Qt/Wayland 支持 |
| `fonts` | Maple Mono、Noto、Fira Code、Bibata 光标、`fc-cache` |
| `gnome` | GDM、GNOME Shell 组件、扩展（gsettings）、power-profiles-daemon |
| `niri` | niri、xwayland-satellite、portal、截图/媒体/亮度工具 |
| `dms` | Dux Modular Shell（官方 extra 的 `dux-shell`）及 matugen/cava/qt6ct/jq 等依赖 |
| `apps` | VS Code（AUR bin）、Chrome（AUR）、Timeshift |
| `dsh` | DeepSeek Harness Web（`npx @deepseek-ai/dsh@next web`）、桌面入口，并移除旧的 AUR Electron 包 |
| `code` | 把 VS Code 的 `User/settings.json` 链接进真实的 `~/.config/Code`（该目录不整体 stow，避免缓存进仓库） |
| `flatpak` | Flatpak + flathub 源 + Flatseal |

默认 profile 会一次安装全部 14 个模块：GNOME（GDM、扩展、电源）与 niri（合成器、DMS、
截图/媒体工具）**同时装好**，登录界面选择用哪个会话即可。profile 定义在 `install/profiles/*.list`，
包清单在 `install/packages/*.list`。
每个包清单都会被自动分类：能在 pacman 仓库找到的用 `pacman` 安装，其余交给 AUR helper。

## 目录说明

| 路径 | 说明 |
| --- | --- |
| `install.sh` | 入口：参数解析、preflight、模块调度、最终校验 |
| `lib/` | 公共函数库，见 [lib/README.md](lib/README.md) |
| `modules/` | 各模块脚本，见 [modules/README.md](modules/README.md) |
| `packages/` | 各模块包清单，见 [packages/README.md](packages/README.md) |
| `profiles/` | profile（模块执行顺序），见 [profiles/README.md](profiles/README.md) |

## 脚本不会做的事

- 不会切换登录会话：请在登录界面自行选择 `niri` 或 `GNOME`。
- 不会在已有其他显示管理器时改动默认显示管理器。
- 不会安装你已从清单中移除的包（tmux、Docker/KVM、Steam、旧的 flatpak 微信/QQ/WPS 应用集）。
- 不会动 `~/.ssh`、浏览器 profile 等用户数据。
- 不会把 `~/.config/Code` 作为目录 stow：VS Code 会在那里写缓存和 globalStorage，
  所以只把 `User/settings.json` 软链进真实目录。

## 执行之后

1. 注销并重新登录（或重启），让输入法/会话设置生效。
2. 在登录界面选择 **niri** 会话（GNOME 为辅线）。
3. 如果 shell 模块没能拉取 zim 模块，首次打开交互式 shell 会自动补齐；若跳过了
   Neovim 插件恢复，首次启动 `nvim` 会自行安装。
4. 首次进入 niri 后 DMS 会自动启动。`dms` 模块会用
   `install/templates/dms-session.json` 初始化 `~/.local/state/dms/session.json`
   （壁纸、天气、中文日期）；之后 DMS 会自行维护该文件。也可手动设置壁纸：
   `dms ipc call wallpaper set ~/.config/wallpapers/arch-purple.jpeg`。
5. 随时可以重新执行 `niri validate`、`dms doctor` 检查配置。

## 恢复备份

冲突文件会按相对路径移到 `~/.dotfiles-backup-<时间戳>/`，例如
`~/.dotfiles-backup-20260101-120000/.config/ghostty/config`。想回滚单个文件时把它移回去即可。
