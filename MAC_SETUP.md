# Bash Copilot - macOS 设置指南

本指南专门针对 macOS 用户的快捷键配置和常见问题。

## 🚨 立即解决：Ctrl+O 不工作

你遇到的问题：`Ctrl+O` 在 macOS 上不响应。

### 为什么 Ctrl+O 不工作？

在 macOS 的 bash 中，**Ctrl+O 已经被绑定到 readline 的默认功能**：
- `operate-and-get-next` (接受当前行并获取下一个历史命令)
- Terminal.app 和 iTerm2 可能也占用了这个快捷键

### ✅ 立即解决方案（3选1）

#### 方案 1：使用 Ctrl+G（推荐）

```bash
export BASH_COPILOT_HOTKEY=ctrl-g
source ~/.bash_profile
```

**为什么选 Ctrl+G？**
- ✅ 在 macOS 所有终端都可用
- ✅ 很少被其他程序占用
- ✅ 容易按（单手操作）

#### 方案 2：使用 F2（最可靠）

```bash
export BASH_COPILOT_HOTKEY=f2
source ~/.bash_profile
```

**为什么选 F2？**
- ✅ 100% 不会冲突
- ✅ 在所有终端都能工作
- ✅ 易于记忆

#### 方案 3：使用 Alt+C（需要配置）

```bash
# 1. 先配置终端
# Terminal.app: Preferences > Profiles > Keyboard
#   勾选 "Use Option as Meta key"
#
# iTerm2: Preferences > Profiles > Keys
#   设置 Left/Right Option key 为 "Esc+"

# 2. 设置环境变量
export BASH_COPILOT_HOTKEY=alt-c
source ~/.bash_profile
```

## 🔧 验证配置

### 第 1 步：检查环境变量
```bash
echo $BASH_COPILOT_HOTKEY
```
应该输出你设置的值，如：`ctrl-g`

### 第 2 步：重新加载配置
```bash
# macOS 通常使用 .bash_profile
source ~/.bash_profile

# 或者重启终端
```

### 第 3 步：检查是否加载
```bash
echo $BASH_COPILOT_LOADED
```
应该输出：`1`

### 第 4 步：查看绑定
```bash
bind -P | grep bash_copilot
```
应该看到类似：
```
"\C-g": _bash_copilot_complete
```

### 第 5 步：测试热键
```bash
# 输入一些文本
find large files

# 然后按你设置的快捷键（如 Ctrl+G）
```

## 🧪 测试工具

运行 Mac 专用测试脚本：

```bash
cd ~/repos/fe/bash-copilot
./test_mac_hotkeys.sh
```

这个脚本会：
- 测试所有快捷键是否可以绑定
- 显示当前终端配置
- 给出针对性建议
- 提供交互式测试

## 🍎 macOS 终端配置

### Terminal.app（系统自带）

#### 启用 Option 键作为 Meta 键
1. 打开 **Terminal > Preferences**
2. 选择 **Profiles** 标签
3. 选择你的配置文件（通常是 "Basic" 或 "Default"）
4. 点击 **Keyboard** 标签
5. 勾选 **"Use Option as Meta key"**

这样就可以使用 Alt 快捷键了。

#### 推荐快捷键配置
```bash
# 添加到 ~/.bash_profile
export BASH_COPILOT_HOTKEY=ctrl-g
```

### iTerm2

#### 启用 Option 键
1. 打开 **iTerm2 > Preferences** (⌘,)
2. 选择 **Profiles** 标签
3. 选择你的配置文件
4. 点击 **Keys** 标签
5. 设置 **Left Option Key** 为 **Esc+**
6. 设置 **Right Option Key** 为 **Esc+**

#### 推荐快捷键配置
```bash
# 添加到 ~/.bash_profile 或 ~/.zshrc (如果用 zsh)
export BASH_COPILOT_HOTKEY=ctrl-g
# 或者使用 Alt 键
export BASH_COPILOT_HOTKEY=alt-c
```

### Alacritty

在 `~/.config/alacritty/alacritty.yml` 中：
```yaml
key_bindings:
  # 不要绑定冲突的键
```

推荐使用：
```bash
export BASH_COPILOT_HOTKEY=ctrl-g
```

## ❌ macOS 上不推荐的快捷键

### 这些快捷键可能不工作或有冲突：

| 快捷键 | 原因 | 替代方案 |
|--------|------|----------|
| **Ctrl+O** | readline 默认绑定 | 用 Ctrl+G |
| **Ctrl+S** | 终端流控制（冻结输出） | 用 Ctrl+G |
| **Ctrl+Q** | 终端流控制 | 用 Ctrl+G |
| **Ctrl+Z** | 挂起进程 | 用 Ctrl+G |
| **Ctrl+C** | 中断进程 | 用 Ctrl+G |
| **Ctrl+D** | 退出 shell | 用 Ctrl+G |
| **Ctrl+L** | 清屏 | 用 Ctrl+G |
| **Alt+Space** | Spotlight/系统快捷键 | 用 Alt+C |

## ✅ macOS 上推荐的快捷键

按优先级排序：

### 1. Ctrl+G（最推荐）⭐⭐⭐⭐⭐
```bash
export BASH_COPILOT_HOTKEY=ctrl-g
```
- ✅ 所有终端都支持
- ✅ 无需额外配置
- ✅ 不与系统快捷键冲突

### 2. F2（最可靠）⭐⭐⭐⭐⭐
```bash
export BASH_COPILOT_HOTKEY=f2
```
- ✅ 100% 兼容
- ✅ 不会有任何冲突
- ✅ 容易记忆

### 3. Alt+C（需配置 Option 键）⭐⭐⭐⭐
```bash
export BASH_COPILOT_HOTKEY=alt-c
```
- ✅ 单手操作舒适
- ⚠️ 需要配置 Option 作为 Meta 键

### 4. Ctrl+P（可能冲突）⭐⭐⭐
```bash
export BASH_COPILOT_HOTKEY=ctrl-p
```
- ⚠️ 可能与历史命令上翻冲突
- 建议只在不使用 Ctrl+P/Ctrl+N 导航历史的情况下使用

## 🔍 诊断快捷键问题

### 检查快捷键是否被占用

```bash
# 查看所有 readline 绑定
bind -P | grep "\\C-o"

# 输出示例：
# "\C-o": operate-and-get-next
```

如果看到已有绑定，说明这个键被占用了。

### 查看哪些键可用

```bash
# 运行测试脚本
./test_mac_hotkeys.sh
```

### 手动测试绑定

```bash
# 测试 Ctrl+G
bind -x '"\C-g": echo "Ctrl+G works!"'
# 然后按 Ctrl+G，应该输出 "Ctrl+G works!"

# 移除测试绑定
bind -r "\C-g"
```

## 🚀 完整配置步骤

### 对于 Terminal.app 用户

```bash
# 1. 编辑配置文件
nano ~/.bash_profile

# 2. 添加以下内容
export BASH_COPILOT_HOTKEY=ctrl-g

# 3. 如果还没安装，添加 source 语句
# source "/path/to/bash-copilot/bash_copilot_completion.sh"

# 4. 保存并退出 (Ctrl+X, Y, Enter)

# 5. 重新加载
source ~/.bash_profile

# 6. 验证
echo $BASH_COPILOT_HOTKEY
echo $BASH_COPILOT_LOADED

# 7. 测试
# 输入: find large files
# 按: Ctrl+G
```

### 对于 iTerm2 用户

```bash
# 1. 配置 Option 键（见上文）

# 2. 编辑配置文件
nano ~/.bash_profile

# 3. 添加
export BASH_COPILOT_HOTKEY=alt-c
# 或者
export BASH_COPILOT_HOTKEY=ctrl-g

# 4. 重新加载
source ~/.bash_profile

# 5. 测试
```

## 🔄 重置所有绑定

如果快捷键完全混乱了：

```bash
# 1. 关闭所有终端窗口

# 2. 编辑 ~/.bash_profile
nano ~/.bash_profile

# 3. 确保只有一个 BASH_COPILOT_HOTKEY 设置
# 删除所有重复的行，只保留：
export BASH_COPILOT_HOTKEY=ctrl-g

# 4. 保存退出

# 5. 打开新终端

# 6. 验证
source ~/.bash_profile
echo $BASH_COPILOT_HOTKEY
bind -P | grep bash_copilot
```

## 🐛 常见问题

### Q: 为什么 export 后还是不工作？

**A:** 你需要重新加载配置：
```bash
source ~/.bash_profile
# 或者重启终端
```

### Q: ~/.bashrc 还是 ~/.bash_profile？

**A:** 在 macOS 上：
- **登录 shell** (Terminal.app 默认) → 使用 `~/.bash_profile`
- **交互式 shell** → 使用 `~/.bashrc`

**建议：** 在 `~/.bash_profile` 中添加：
```bash
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
```

### Q: 我用的是 zsh，怎么配置？

**A:** 虽然这个工具是为 bash 设计的，但如果你在 zsh 中：
```bash
# 添加到 ~/.zshrc
# Bash Copilot 需要 bash
```

注意：Bash Copilot 目前只支持 bash，不支持 zsh。

### Q: Ctrl+O 能强制使用吗？

**A:** 可以，但不推荐。你需要先解除绑定：
```bash
# 在 bash_copilot_completion.sh 加载之前
bind -r "\C-o"
export BASH_COPILOT_HOTKEY=ctrl-o
```

但这会失去 `operate-and-get-next` 功能。**建议使用 Ctrl+G**。

## 📝 配置文件示例

### 最小配置 (~/.bash_profile)

```bash
# Bash Copilot
export BASH_COPILOT_HOTKEY=ctrl-g
source "/Users/yourusername/repos/fe/bash-copilot/bash_copilot_completion.sh"
```

### 完整配置 (~/.bash_profile)

```bash
# ===== Bash Copilot Configuration =====

# 设置快捷键
export BASH_COPILOT_HOTKEY=ctrl-g

# 可选：配置 API（或者用 bash-copilot config）
# export OPENAI_API_KEY="sk-your-key-here"

# 加载补全脚本
BASH_COPILOT_PATH="/Users/yourusername/repos/fe/bash-copilot"
if [ -f "${BASH_COPILOT_PATH}/bash_copilot_completion.sh" ]; then
    source "${BASH_COPILOT_PATH}/bash_copilot_completion.sh"
fi

# ===== End Bash Copilot Configuration =====
```

### 高级配置（多环境）

```bash
# 根据终端类型选择快捷键
if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
    # Terminal.app
    export BASH_COPILOT_HOTKEY=ctrl-g
elif [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    # iTerm2 - Option 键已配置
    export BASH_COPILOT_HOTKEY=alt-c
else
    # 其他终端
    export BASH_COPILOT_HOTKEY=f2
fi

source "/path/to/bash_copilot_completion.sh"
```

## 🎯 快速参考卡

```
╔════════════════════════════════════════╗
║   Bash Copilot - macOS Quick Ref      ║
╟────────────────────────────────────────╢
║ 推荐快捷键:                             ║
║   Ctrl+G  (ctrl-g)      ⭐⭐⭐⭐⭐      ║
║   F2      (f2)          ⭐⭐⭐⭐⭐      ║
║   Alt+C   (alt-c)*      ⭐⭐⭐⭐       ║
║   * 需配置 Option 键                   ║
╟────────────────────────────────────────╢
║ 配置文件: ~/.bash_profile              ║
║ 重新加载: source ~/.bash_profile       ║
║ 测试脚本: ./test_mac_hotkeys.sh        ║
║ 诊断工具: ./diagnose.sh                ║
╟────────────────────────────────────────╢
║ 验证命令:                               ║
║   echo $BASH_COPILOT_HOTKEY            ║
║   echo $BASH_COPILOT_LOADED            ║
║   bind -P | grep bash_copilot          ║
╚════════════════════════════════════════╝
```

## 📚 相关文档

- [QUICKSTART.md](QUICKSTART.md) - 快速开始
- [HOTKEYS.md](HOTKEYS.md) - 所有快捷键说明
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - 详细故障排除

## 💡 需要帮助？

1. **运行诊断：** `./diagnose.sh`
2. **测试热键：** `./test_mac_hotkeys.sh`
3. **查看日志：** 输入命令时按快捷键，观察输出
4. **重置配置：** 删除 `~/.bash_profile` 中的相关行，重新开始

---

**macOS 用户推荐配置：**
```bash
export BASH_COPILOT_HOTKEY=ctrl-g
```

简单、可靠、无冲突！🎉
