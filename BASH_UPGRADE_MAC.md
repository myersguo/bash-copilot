# 🍎 macOS Bash 升级指南

## 🚨 为什么需要升级 Bash？

你的测试显示所有快捷键绑定都失败了，这是因为：

**问题：** macOS 默认的 Bash 版本是 **3.2.57**（发布于 2007 年！）
**要求：** Bash Copilot 需要 **Bash 4.0+**（因为使用了 `bind -x` 功能）

Apple 一直使用 Bash 3.2 是因为 Bash 4+ 使用 GPLv3 许可证，Apple 不想接受这个许可证。

## ✅ 快速解决方案（推荐）

### 方案 1：安装现代 Bash（推荐）⭐⭐⭐⭐⭐

使用 Homebrew 安装最新的 Bash：

```bash
# 1. 如果还没有 Homebrew，先安装它
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. 安装最新版 Bash
brew install bash

# 3. 查看安装的位置
which -a bash
# 应该看到：
#   /opt/homebrew/bin/bash  (Apple Silicon)
#   /usr/local/bin/bash     (Intel Mac)
#   /bin/bash               (系统自带的旧版)

# 4. 检查版本
/opt/homebrew/bin/bash --version    # Apple Silicon
/usr/local/bin/bash --version       # Intel Mac
# 应该显示 5.x 或更高

# 5. 将新版 Bash 添加到允许的 shell 列表
echo "/opt/homebrew/bin/bash" | sudo tee -a /etc/shells     # Apple Silicon
# 或
echo "/usr/local/bin/bash" | sudo tee -a /etc/shells        # Intel Mac

# 6. 设置为默认 shell
chsh -s /opt/homebrew/bin/bash      # Apple Silicon
# 或
chsh -s /usr/local/bin/bash         # Intel Mac

# 7. 重启终端或重新登录

# 8. 验证
bash --version
# 应该显示 5.x
```

### 方案 2：使用 zsh（macOS Catalina 10.15+ 默认）⭐⭐⭐

如果你的 macOS 是 Catalina 或更新版本，可以考虑切换到 zsh：

```bash
# 1. 检查 zsh 版本
zsh --version

# 2. 切换到 zsh
chsh -s /bin/zsh

# 3. 重启终端
```

**注意：** 当前 Bash Copilot 还不完全支持 zsh，需要一些修改。我们建议升级 Bash。

## 📋 详细安装步骤

### 第 1 步：检查当前 Bash 版本

```bash
bash --version
```

如果显示 `3.2.57`，你需要升级。

### 第 2 步：安装 Homebrew（如果还没有）

```bash
# 检查是否已安装
brew --version

# 如果没有，安装 Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 第 3 步：安装现代 Bash

```bash
# 安装 Bash 5.x
brew install bash

# 查看安装位置
brew --prefix bash
```

### 第 4 步：确定你的 Mac 架构

```bash
# 检查是 Apple Silicon 还是 Intel
uname -m

# arm64 = Apple Silicon (M1/M2/M3)
# x86_64 = Intel
```

**Apple Silicon (M1/M2/M3) Mac：**
- Homebrew 安装在 `/opt/homebrew/`
- Bash 位于 `/opt/homebrew/bin/bash`

**Intel Mac：**
- Homebrew 安装在 `/usr/local/`
- Bash 位于 `/usr/local/bin/bash`

### 第 5 步：添加新 Bash 到允许的 Shell 列表

```bash
# 查看当前允许的 shells
cat /etc/shells

# Apple Silicon Mac
echo "/opt/homebrew/bin/bash" | sudo tee -a /etc/shells

# Intel Mac
echo "/usr/local/bin/bash" | sudo tee -a /etc/shells
```

### 第 6 步：设置为默认 Shell

```bash
# Apple Silicon Mac
chsh -s /opt/homebrew/bin/bash

# Intel Mac
chsh -s /usr/local/bin/bash

# 输入密码确认
```

### 第 7 步：重新启动终端

**完全关闭 Terminal.app 并重新打开**（Command+Q 然后重新启动）

### 第 8 步：验证

```bash
# 检查当前 shell
echo $SHELL
# 应该显示 /opt/homebrew/bin/bash 或 /usr/local/bin/bash

# 检查版本
bash --version
# 应该显示类似：GNU bash, version 5.2.x

# 检查 bind -x 是否可用
type bind
bind -x '"\C-t": echo test'
# 应该没有错误
```

## 🔧 配置 Bash Copilot

升级 Bash 后，重新配置：

```bash
# 1. 进入项目目录
cd ~/repos/fe/bash-copilot

# 2. 设置快捷键（在新 bash 5.x 中）
export BASH_COPILOT_HOTKEY=ctrl-g

# 3. 添加到配置文件
# 使用 Bash 5.x 后，配置文件是 ~/.bash_profile 或 ~/.bashrc
nano ~/.bash_profile

# 4. 添加以下内容：
export BASH_COPILOT_HOTKEY=ctrl-g
source "/Users/yourusername/repos/fe/bash-copilot/bash_copilot_completion.sh"

# 5. 保存并重新加载
source ~/.bash_profile

# 6. 测试
echo $BASH_COPILOT_LOADED
# 应该显示 1

# 7. 再次运行测试脚本
./test_mac_hotkeys.sh
# 现在应该成功！
```

## 🧪 验证 Bash 升级

运行完整测试：

```bash
# 1. 检查 Bash 版本
bash --version

# 2. 检查 bind -x 功能
bash -c 'bind -x '"'"'"\C-t": echo "It works!"'"'"'; echo "Binding succeeded"'

# 3. 运行 Mac 测试工具
cd ~/repos/fe/bash-copilot
./test_mac_hotkeys.sh

# 4. 应该看到成功的绑定
# ✓ ctrl-g (Ctrl+G) - binding created successfully
```

## ⚠️ 常见问题

### Q: 升级后终端显示 "illegal option" 错误

**A:** 你的 `~/.bash_profile` 或 `~/.bashrc` 可能包含 Bash 3.2 特有的语法。检查并更新：

```bash
# 检查配置文件语法
bash -n ~/.bash_profile
bash -n ~/.bashrc
```

### Q: chsh 提示 "non-standard shell"

**A:** 确保你已将新 Bash 添加到 `/etc/shells`：

```bash
cat /etc/shells | grep homebrew
# 应该看到 /opt/homebrew/bin/bash 或 /usr/local/bin/bash

# 如果没有，添加它
echo "/opt/homebrew/bin/bash" | sudo tee -a /etc/shells  # Apple Silicon
```

### Q: Terminal 还是使用旧版 Bash

**A:** 确保完全重启了 Terminal.app：

```bash
# 1. 完全退出 Terminal (Command+Q)
# 2. 重新打开
# 3. 检查
echo $SHELL
bash --version
```

### Q: 我不想更改默认 Shell

**A:** 你可以只在特定终端窗口使用新 Bash：

```bash
# 每次打开终端时运行
/opt/homebrew/bin/bash  # Apple Silicon
# 或
/usr/local/bin/bash     # Intel

# 或者在 Terminal 偏好设置中设置启动命令
```

### Q: 可以同时保留两个版本吗？

**A:** 可以！系统 Bash 仍在 `/bin/bash`，新 Bash 在 Homebrew 目录。你可以明确指定使用哪个：

```bash
/bin/bash --version           # 3.2.57
/opt/homebrew/bin/bash --version  # 5.2.x
```

## 🔄 回退到系统 Bash

如果需要回退：

```bash
# 1. 恢复默认 shell
chsh -s /bin/bash

# 2. 重启终端

# 3. (可选) 卸载 Homebrew Bash
brew uninstall bash
```

## 📊 Bash 版本对比

| 功能 | Bash 3.2 | Bash 4.0+ | Bash 5.0+ |
|------|----------|-----------|-----------|
| `bind -x` | ❌ | ✅ | ✅ |
| 关联数组 | ❌ | ✅ | ✅ |
| `**` globstar | ❌ | ✅ | ✅ |
| 发布年份 | 2007 | 2009 | 2019 |
| 仍在维护 | ❌ | ❌ | ✅ |

**结论：** Bash 3.2 太旧了，许多现代功能都不支持。

## 🎯 推荐设置

安装 Bash 5+ 后的最佳配置：

**~/.bash_profile:**
```bash
# Bash Copilot Configuration
export BASH_COPILOT_HOTKEY=ctrl-g

# Source completion script
BASH_COPILOT_DIR="$HOME/repos/fe/bash-copilot"
if [ -f "${BASH_COPILOT_DIR}/bash_copilot_completion.sh" ]; then
    source "${BASH_COPILOT_DIR}/bash_copilot_completion.sh"
fi

# Also load .bashrc if it exists
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
```

## 🚀 快速命令参考

```bash
# 安装 Bash 5
brew install bash

# Apple Silicon Mac 设置
echo "/opt/homebrew/bin/bash" | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/bash

# Intel Mac 设置
echo "/usr/local/bin/bash" | sudo tee -a /etc/shells
chsh -s /usr/local/bin/bash

# 验证
bash --version
echo $SHELL

# 配置 Bash Copilot
export BASH_COPILOT_HOTKEY=ctrl-g
source ~/.bash_profile

# 测试
./test_mac_hotkeys.sh
```

## 📚 更多资源

- [Homebrew 官网](https://brew.sh/)
- [Bash 5 发布说明](https://www.gnu.org/software/bash/)
- [为什么 macOS 使用旧 Bash](https://thenextweb.com/news/apple-not-updating-bash-macos-licensing)

## ⏱️ 总时间

整个升级过程大约需要 **5-10 分钟**：
- 安装 Homebrew: 2-3 分钟（如果还没有）
- 安装 Bash 5: 1-2 分钟
- 配置: 2-3 分钟
- 测试: 1 分钟

## ✅ 完成后

升级完成后，你应该能够：
- ✅ 使用所有快捷键（Ctrl+G, F2, Alt+C 等）
- ✅ `bind -x` 命令正常工作
- ✅ 运行 `./test_mac_hotkeys.sh` 看到成功的绑定
- ✅ Bash Copilot 完全功能

---

**需要帮助？** 如果升级过程中遇到问题，运行 `./diagnose.sh` 获取详细诊断信息。
