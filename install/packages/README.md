# install/packages —— 包清单

每个文件是一份包清单，供同名模块通过 `install_packages` 读取。清单里的包会被**自动分类**：
`pacman -Si <包名>` 能查到的走 `pacman -S --needed`，查不到的交给 AUR helper（默认 paru）。

## 文件与模块对应

| 清单文件 | 使用模块 | 内容（AUR / archlinuxcn 已标注） |
| --- | --- | --- |
| `base.list` | `base` | base-devel、git、stow、curl、wget、unzip、rsync |
| `shell.list` | `shell` | zsh、**zimfw（AUR）**、starship、direnv、zoxide、fzf、fd、ripgrep、bat、eza、yazi、7zip、resvg、chafa |
| `terminal.list` | `terminal` | ghostty |
| `neovim.list` | `neovim` | neovim、nodejs、npm、python、stylua、prettier、python-black、codespell、clang、go、tree-sitter-cli、lazygit |
| `fcitx5.list` | `fcitx5` | fcitx5、fcitx5-gtk、fcitx5-qt、fcitx5-configtool、fcitx5-chinese-addons、qt5-wayland、qt6-wayland |
| `fonts.list` | `fonts` | **ttf-maplemononl-nf-cn（archlinuxcn）**、noto-fonts、noto-fonts-cjk、noto-fonts-emoji、ttf-firacode-nerd、**bibata-cursor-theme（AUR）** |
| `gnome.list` | `gnome` | gdm、gnome-shell、gnome-tweaks、xdg-desktop-portal-gnome、xdg-desktop-portal-gtk、extension-manager、power-profiles-daemon、gnome-shell-extension-appindicator、**gnome-shell-extension-dash-to-dock（archlinuxcn）**、**clipboard-indicator / blur-my-shell（AUR）** |
| `niri.list` | `niri` | niri、xwayland-satellite、polkit-gnome、playerctl、brightnessctl、wl-clipboard、grim、slurp、satty |
| `dms.list` | `dms` | `dux-shell`（官方 extra，依赖 quickshell）、jq、matugen、cava、wtype、qt6ct、adw-gtk-theme、bluez、bluez-utils |
| `apps.list` | `apps` | **visual-studio-code-bin（AUR）**、**google-chrome（AUR）**、timeshift |
| `dsh.list` | `dsh` | nodejs、npm（`npx` 来自 npm；DeepSeek Harness 本体由 npx 缓存） |
| `flatpak.list` | `flatpak` | flatpak 应用 id：`com.github.tchx84.Flatseal`（**不是 pacman 包名**） |

## 格式

- 一行一个包，`#` 开头为注释，行内 `#` 之后也会被忽略。
- **不要写版本号**（不要 `foo=1.2.3`），Arch/AUR 始终取最新版本。
- 空行会被忽略。
- 文件名与模块 id 保持一致（`<id>.list`）；`flatpak.list` 是唯一的例外，内容是 flatpak 应用 id。

示例：

```text
# Shell: zsh 生态
zsh
zimfw
starship
```

## 来源与限制

| 来源 | 前提 | 说明 |
| --- | --- | --- |
| 官方仓库（core/extra） | 无 | 直接 `pacman -S` |
| archlinuxcn | `base` 模块已添加 `[archlinuxcn]` 源 | 需要网络；keyring 失败时相关包可能校验失败 |
| AUR | 有 AUR helper | `--no-aur` 时会跳过这些包并给出 warn |
| flatpak | `flatpak` 模块 | 只读 `flatpak.list`，在 flathub 上安装 |

## 增删包

1. 直接把包名加进/删出对应模块的 `.list`。
2. 新模块要建同名清单；`flatpak` 模块使用 `flatpak.list`。
3. 判断来源：

   ```bash
   pacman -Si <包名>   # 有输出=仓库包；无输出=需要 AUR
   ```

4. 预览分类和安装命令：

   ```bash
   install/install.sh --dry-run --only <模块 id>
   ```

   输出里 `pacman: ...` 是仓库包，`AUR (...) : ...` 是 AUR 包。

## 注意

- 同一模块的清单不要混入无关模块的包，保持「模块 ↔ 清单」一一对应。
- 大体积/编译型 AUR 包（如 `visual-studio-code-bin`、`google-chrome`）本身是 bin 包，
  不编译源码；AUR 构建时间主要花在下载上。
- 如果某个包在仓库和 AUR 同名，脚本优先仓库版本。
