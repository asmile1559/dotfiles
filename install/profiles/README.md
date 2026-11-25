# install/profiles —— Profile 定义

一个 profile 就是一个**模块执行顺序清单**。文件名（去掉 `.list`）即传给
`install.sh --profile <名字>` 的值。

**本仓库只使用一个默认 profile：`default.list`。** 它不区分桌面会话，会在 GNOME 基础系统上
一次性把 GNOME 与 niri 两套环境都装好，登录时在 GDM 选择会话即可。

## default.list

| 项 | 内容 |
| --- | --- |
| 文件 | `default.list` |
| 用途 | 完整安装（GNOME 基础 + niri + DMS + 全部工具） |
| 模块顺序 | base → stow → shell → terminal → neovim → fcitx5 → fonts → gnome → niri → dms → apps → code → flatpak |

被移除的模块（tmux、Docker/KVM、Steam 等）不在任何 profile 中。

## 使用

```bash
# 默认完整安装（不需要传 --profile）
install/install.sh

# 先预览最终会运行哪些模块（看输出的 modules: 行）
install/install.sh --dry-run

# --only 完全取代 profile：只按参数里的模块运行
install/install.sh --only fonts,code

# --skip 在默认 profile 基础上剔除模块
install/install.sh --skip flatpak,neovim
```

`--profile` 仍然保留，只是为将来可能出现的自定义组合准备；日常使用不需要指定。

## 文件格式

一行一个模块 id，`#` 行为注释，空行忽略：

```text
# 默认 profile：GNOME 基础 + niri，一次装好。
base
stow
shell
```

## 顺序原则

- `base` **必须最靠前**：它负责系统升级、添加 archlinuxcn 源、安装 `stow` 并准备 AUR helper；
  后面的模块依赖这些前提。
- `stow` 紧随 `base`：让配置尽早就位，后续模块（如 ghostty 校验、code 链接）才能检测到文件。
- `gnome` 与 `niri` 无强制先后，但按「先 GNOME 基础、再 niri 会话」的顺序更贴近实际使用。
- `code` 放在 `apps` 之后即可（它只做软链，不依赖安装顺序）。

## 新建自定义 profile（可选）

1. 复制 `default.list` 为 `profiles/<名字>.list`。
2. 按需要增删模块 id（模块必须存在于 `modules/<id>.sh`，否则脚本会报错并退出）。
3. 用 `--dry-run --profile <名字>` 验证输出中的 `modules:` 列表。
4. 想改默认行为，直接改 `default.list` 或 `install.sh` 里的 `PROFILE="${PROFILE:-default}"`。

## 校验

- 模块 id 拼错 → 运行时报 `unknown module: <id>` 并退出。
- profile 为空或全部被 `--skip` 掉 → 报 `no modules selected`。
- profile 名不存在 → 自动回退到 `default` 并给 warn。
