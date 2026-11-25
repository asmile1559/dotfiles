# 我的 Dotfiles

个人 Arch Linux 配置文件仓库，使用 [GNU Stow](https://www.gnu.org/software/stow/) 的
「整个仓库作为单个 package」布局：仓库内容镜像 `$HOME`，通过 `stow .` 应用。

## 会话

| 角色 | 会话 | 说明 |
| --- | --- | --- |
| 主力 | **niri** + **Dux Modular Shell** | 可滚动平铺的 Wayland 合成器 + Quickshell/Material 3 桌面 shell（DMS 2.x） |
| 备用 | **GNOME** | 后备会话；显示管理器为 GDM |

GDM 两边共用：安装脚本会**在 GNOME 基础系统上一次装好两套会话**（GNOME + niri + DMS），
登录时按需选择即可，不需要分别安装。

## 模块

| 模块 | 配置路径 | 软件包 |
| --- | --- | --- |
| Shell | `.zshenv`、`.config/zsh/`、`.config/starship.toml` | `zsh`、`zimfw`（AUR）、`starship`、`direnv`、`zoxide`、`fzf`、`fd`、`ripgrep`、`bat`、`eza`、`yazi`、`7zip`、`resvg`、`chafa` |
| 终端 | `.config/ghostty/` | `ghostty` |
| 编辑器（Neovim） | `.config/nvim/` | `neovim`（LazyVim）、`stylua`、`prettier`、`python-black`、`codespell`、`clang`、`go`、`tree-sitter-cli`、`lazygit` |
| 编辑器（VS Code） | `.config/Code/User/settings.json`（由安装脚本单独链接，目录本身不 stow） | `visual-studio-code-bin`（AUR） |
| 输入法 | `.config/fcitx5/`、`.local/share/fcitx5/`、`.config/environment.d/`、`.config/autostart/` | `fcitx5`、`fcitx5-gtk`、`fcitx5-qt`、`fcitx5-configtool`、`fcitx5-chinese-addons`、`qt5-wayland`、`qt6-wayland` |
| 字体与光标 | `.config/fontconfig/` | `ttf-maplemononl-nf-cn`、`noto-fonts`、`noto-fonts-cjk`、`noto-fonts-emoji`、`ttf-firacode-nerd`、`bibata-cursor-theme`（AUR） |
| 窗口管理器 | `.config/niri/` | `niri`、`xwayland-satellite` |
| 桌面 shell | `.config/dms/` | `dux-shell`（DMS，官方 extra）、`matugen`、`cava`、`wtype`、`qt6ct`、`adw-gtk-theme`、`jq` |
| 截图 / 剪贴板 | `.config/satty/` | `satty`、`grim`、`slurp`、`wl-clipboard` |
| 窗口管理器集成 | `.config/xdg-desktop-portal/niri-portals.conf` | `xdg-desktop-portal-gnome`、`xdg-desktop-portal-gtk` |
| 媒体 / 亮度 | niri 快捷键 | `playerctl`、`brightnessctl` |
| GNOME | 系统默认 | `gnome-shell`、`gdm`、`extension-manager`；扩展：appindicator、dash-to-dock、clipboard-indicator、blur-my-shell |
| 浏览器 | — | `google-chrome`（AUR） |
| DeepSeek Harness | `.local/bin/dsh-web`、`.local/share/applications/deepseek-ai-dsh.desktop` | `nodejs`、`npm`，通过 `npx @deepseek-ai/dsh@next web` 启动（不使用 AUR Electron 包） |
| 备份 | — | `timeshift` |
| Flatpak | — | Flatseal（`com.github.tchx84.Flatseal`） |
| 电源管理 | — | `power-profiles-daemon` |
| 壁纸 / 头像 | `.config/wallpapers/`、`.face` | — |

## 安装

### 自动安装（推荐）

```bash
git clone https://github.com/asmile1559/dotfiles.git ~/dotfiles
cd ~/dotfiles

install/install.sh --dry-run              # 先预览，不改动任何东西
install/install.sh                        # 在 GNOME 基础上装好全部（含 niri 会话）
install/install.sh --skip flatpak         # 按需跳过某个模块
install/install.sh --only fonts,code      # 或者只运行某几个模块
```

安装脚本会：升级系统、在缺失时添加 `[archlinuxcn]` 仓库、在没有 AUR helper 时自动引导
`paru-bin`、安装各模块的包、把冲突文件备份到 `~/.dotfiles-backup-<时间戳>/`，然后执行
`stow .` 并做最终校验。默认就是「GNOME 基础 + niri 会话」的完整安装，不区分两套 profile；
按需裁剪用 `--only` / `--skip`。所有参数见 [install/README.md](install/README.md)。

其中只存在于 AUR 的包：`zimfw`、`bibata-cursor-theme`、`visual-studio-code-bin`、
`google-chrome`，以及 `clipboard-indicator` / `blur-my-shell` 两个 GNOME 扩展。
DMS 本身（`dux-shell`）及 `matugen`、`cava`、`wtype`、`qt6ct`、`adw-gtk-theme` 都在官方仓库，
不需要 AUR。

### 手动步骤

- 只应用配置：`stow .`（应用前先备份 `$HOME` 中已存在的同名文件）。
- Shell：首次 stow 后运行 `zimfw install`（模块会装到 `~/.config/zsh/.zim`，该目录已 gitignore）。
- Neovim：`:Lazy restore` 会按 `lazy-lock.json` 对齐插件版本。
- 登录 niri 后：
  - `niri validate` 检查合成器配置；
  - `dms doctor` 检查桌面 shell 依赖与配置；
  - 壁纸/天气（南京）/中文日期已由安装脚本写入 DMS session；要换壁纸可用
    `dms ipc call wallpaper set <图片路径>`；
  - 切换浅色/深色：`dms ipc call theme dark` / `dms ipc call theme light`。

## Noctalia → DMS 迁移对照

| 原 Noctalia | 现在 DMS |
| --- | --- |
| 自启 `spawn-at-startup "noctalia"` | `spawn-at-startup "dms" "run"` |
| `Mod+D` → launcher | `Mod+D` → `dms ipc call spotlight toggle` |
| `Mod+Y` → clipboard | `Mod+Y` → `dms ipc call clipboard toggle` |
| `Super+Alt+L` → session lock | `Super+Alt+L` → `dms ipc call lock lock` |
| 控制中心（bar 点击） | bar 点击，或新增 `Mod+A` |
| 电源/会话菜单 | 控制中心或新增 `Mod+X` |
| 左侧竖排 bar | 仍是左侧竖排，顺序保持：launcher/cpu/mem/通知 · 工作区/焦点窗口 · tray/控制中心/时钟 |
| Catppuccin Mocha | `~/.config/dms/themes/catppuccin-mocha.json` 自定义主题（浅色为 Latte） |
| `idle.lockTimeout=300`、`screenOff=600` | `ac/batteryLockTimeout=300`、`ac/batteryMonitorTimeout=600` |
| 底部自动隐藏 dock | DMS dock，底部、自动隐藏、应用分组 |
| 夜间模式关闭、温度 6500/4000K | DMS 夜间模式默认关闭，色温可在 Settings 调整 |

## 说明

- 桌面 shell 已从 **Noctalia v5** 迁移到 **Dux Modular Shell（DMS 2.x）**：
  - 包名 `dux-shell`（官方 extra），CLI 为 `dms`，底层是 Quickshell + Go 后端；
  - 设置文件 `~/.config/dms/settings.json`，自定义主题 `~/.config/dms/themes/catppuccin-mocha.json`；
  - `settings.json` 与主题文件纳入本仓库；DMS 运行时生成的 `plugin_settings.json`、
    `clsettings.json`、插件目录等已在 `.gitignore` 中排除；
  - 壁纸、天气位置与中文日期由 `install/templates/dms-session.json` 在首次安装时写入
    `~/.local/state/dms/session.json`，之后由 DMS 自己维护。
- `install/` 通过 `.stow-local-ignore` 排除，不会链接到 `$HOME`。
- VS Code 与 Chrome 是 AUR **bin** 包（上游二进制重新打包，不在本地编译）。
- `~/.config/Code` **不**作为目录 stow：只把 `User/settings.json`（以及可选的
  `User/keybindings.json`）软链进真实的 `~/.config/Code`，避免 VS Code 的缓存和
  globalStorage 污染本仓库。
- niri 配置拆分为 `.config/niri/config.kdl` 与 `configs/*.kdl`。
- 有意不再维护：tmux、Docker/KVM、Steam，以及旧的 flatpak 微信/QQ/WPS/飞书 应用集。
- 旧的 Noctalia 配置、安装模块、包清单与 v4 归档均已删除；不再需要 `noctalia-git`。

## 目录结构

```
dotfiles/
├── .config/          # 各应用配置（stow 到 ~/.config）
├── .local/           # 用户级数据（fcitx5 主题、DSH 启动器与桌面入口）
├── .zshenv .face     # 顶层文件
├── install/          # 自动安装脚本（不 stow），详见 install/README.md
│   ├── install.sh
│   ├── lib/          # 公共函数
│   ├── modules/      # 模块脚本
│   ├── packages/     # 包清单
│   └── profiles/     # profile 定义
└── README.md
```
