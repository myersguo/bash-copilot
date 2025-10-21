# Bash Copilot 故障排除指南

本指南帮助你解决 Bash Copilot 快捷键不生效及其他常见问题。

## 快速诊断

首先运行诊断工具来快速识别问题：

```bash
cd /path/to/bash-copilot
./diagnose.sh
```

这将自动检查所有常见问题并提供修复建议。

## 快捷键不生效的排查步骤

### 第 1 步：确认脚本已加载

检查环境变量：
```bash
echo $BASH_COPILOT_LOADED
```

**期望输出**: `1`

**如果输出为空**，说明脚本未加载，运行：
```bash
source ~/.bashrc
```

### 第 2 步：检查脚本是否在 .bashrc 中

```bash
grep "bash_copilot_completion.sh" ~/.bashrc
```

**如果没有输出**，需要安装：
```bash
bash-copilot install
source ~/.bashrc
```

### 第 3 步：验证快捷键绑定

查看当前的快捷键绑定：
```bash
bind -P | grep bash_copilot
```

**期望输出**：类似于：
```
"\C-@": _bash_copilot_complete
```

**如果没有输出**，说明绑定未生效，尝试：
```bash
source ~/.bashrc
```

### 第 4 步：检查快捷键配置

```bash
echo $BASH_COPILOT_HOTKEY
```

如果设置了但不生效，确认值是否正确：
```bash
# 查看所有可用预设
bash-copilot hotkeys
```

### 第 5 步：测试完成函数

手动触发完成函数：
```bash
# 输入一些文本
ls /tmp

# 然后直接调用函数（不按快捷键）
_bash_copilot_complete
```

如果这个有效但快捷键无效，说明是快捷键绑定问题。

### 第 6 步：尝试不同的快捷键

有些终端不支持某些快捷键组合。尝试更换：

```bash
# 添加到 ~/.bashrc
export BASH_COPILOT_HOTKEY=ctrl-g
source ~/.bashrc
```

推荐的替代快捷键：
- `ctrl-g` - 通常可用
- `alt-c` - 很少冲突
- `f2` - 功能键最保险

### 第 7 步：检查 API 配置

测试基本功能：
```bash
echo "list files" | bash-copilot complete
```

**如果报错** `Error: OpenAI API key not configured`：
```bash
bash-copilot config --api-key YOUR_API_KEY
```

## 常见问题及解决方案

### 问题 1: 按快捷键没有任何反应

**可能原因**:
- 脚本未加载
- 快捷键被其他程序占用
- 终端不支持该快捷键

**解决方案**:
```bash
# 1. 重新加载配置
source ~/.bashrc

# 2. 检查绑定
bind -P | grep bash_copilot

# 3. 尝试其他快捷键
export BASH_COPILOT_HOTKEY=f2
source ~/.bashrc
```

### 问题 2: 显示 "Error: Failed to get completion"

**可能原因**:
- API key 未配置或无效
- 网络连接问题
- API 配额用尽

**解决方案**:
```bash
# 1. 检查配置
cat ~/.bash-copilot.json

# 2. 重新配置 API key
bash-copilot config --api-key YOUR_NEW_KEY

# 3. 测试 API 连接
echo "test" | bash-copilot complete

# 4. 检查网络
ping api.openai.com
```

### 问题 3: 快捷键与其他工具冲突

**识别冲突**:
```bash
# 查看所有 Ctrl+Space 绑定
bind -P | grep '\\C-@'
```

**解决方案**:
更换为不冲突的快捷键：
```bash
export BASH_COPILOT_HOTKEY=ctrl-g
source ~/.bashrc
```

### 问题 4: 在 tmux 中不工作

**可能原因**:
tmux 可能拦截了某些快捷键

**解决方案**:
```bash
# 使用功能键，通常不会被 tmux 拦截
export BASH_COPILOT_HOTKEY=f2
source ~/.bashrc
```

或在 `~/.tmux.conf` 中解除绑定：
```
unbind C-Space
```

### 问题 5: 在 SSH 会话中不工作

**可能原因**:
- SSH 客户端可能不转发某些按键
- 远程服务器配置未同步

**解决方案**:
```bash
# 1. 确认在远程服务器上安装并配置了 Bash Copilot
bash-copilot --help

# 2. 使用更通用的快捷键
export BASH_COPILOT_HOTKEY=f2
source ~/.bashrc

# 3. 检查 SSH 客户端设置
# 确保终端类型正确
echo $TERM
```

### 问题 6: Python 脚本执行缓慢

**可能原因**:
- API 响应慢
- 网络延迟

**解决方案**:
```bash
# 1. 使用更快的模型
bash-copilot config --model gpt-3.5-turbo

# 2. 使用本地 API 端点
bash-copilot config --base-uri http://localhost:1234/v1

# 3. 检查网络延迟
time echo "test" | bash-copilot complete
```

### 问题 7: 脚本找不到

**错误信息**: `bash-copilot: command not found`

**解决方案**:
```bash
# 方法 1: 创建符号链接
sudo ln -s /path/to/bash-copilot/bash_copilot.py /usr/local/bin/bash-copilot

# 方法 2: 使用完整路径
/path/to/bash-copilot/bash_copilot.py config

# 方法 3: 添加到 PATH
echo 'export PATH="/path/to/bash-copilot:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

## 终端特定问题

### iTerm2 (macOS)

如果 Ctrl+Space 不工作：
```bash
# 在 iTerm2 Preferences > Keys > Key Bindings
# 确保 Ctrl+Space 没有被占用

# 或使用替代快捷键
export BASH_COPILOT_HOTKEY=ctrl-g
```

### Windows Terminal / WSL

```bash
# Windows Terminal 可能占用某些快捷键
# 推荐使用
export BASH_COPILOT_HOTKEY=alt-c
```

### Gnome Terminal

```bash
# 某些 Gnome Terminal 版本的快捷键限制
# 推荐使用
export BASH_COPILOT_HOTKEY=f2
```

### macOS Terminal

```bash
# Option 键默认用于特殊字符
# 在 Terminal > Preferences > Profiles > Keyboard
# 勾选 "Use Option as Meta key"

export BASH_COPILOT_HOTKEY=alt-c
```

## 调试技巧

### 启用详细日志

临时调试模式：
```bash
# 设置 bash 调试
set -x

# 手动调用函数
_bash_copilot_complete

# 关闭调试
set +x
```

### 测试 readline 绑定

```bash
# 列出所有绑定
bind -P

# 测试特定按键
bind -x '"\C-x": echo "Ctrl+X works!"'
# 然后按 Ctrl+X
```

### 检查脚本语法

```bash
# 检查 bash 脚本语法
bash -n /path/to/bash-copilot/bash_copilot_completion.sh

# 检查 Python 脚本语法
python3 -m py_compile /path/to/bash-copilot/bash_copilot.py
```

### 手动测试 API

```bash
# 直接测试 OpenAI API
curl https://api.openai.com/v1/models \
  -H "Authorization: Bearer YOUR_API_KEY"
```

## 重置配置

如果一切都不工作，尝试完全重置：

```bash
# 1. 备份现有配置
cp ~/.bash-copilot.json ~/.bash-copilot.json.backup

# 2. 移除旧配置
rm ~/.bash-copilot.json

# 3. 从 .bashrc 移除
sed -i.bak '/bash_copilot_completion.sh/d' ~/.bashrc

# 4. 重新安装
cd /path/to/bash-copilot
./install.sh

# 5. 重新配置
bash-copilot config

# 6. 重新加载
source ~/.bashrc
```

## 环境检查清单

在报告问题前，请检查：

- [ ] Python 3.6+ 已安装: `python3 --version`
- [ ] 脚本文件存在且可执行: `ls -la bash_copilot*.py bash_copilot*.sh`
- [ ] .bashrc 包含 source 语句: `grep bash_copilot ~/.bashrc`
- [ ] 环境变量已设置: `echo $BASH_COPILOT_LOADED`
- [ ] API key 已配置: `cat ~/.bash-copilot.json`
- [ ] 快捷键绑定已创建: `bind -P | grep bash_copilot`
- [ ] 基本功能测试通过: `echo "test" | bash-copilot complete`
- [ ] 已尝试不同的快捷键: `bash-copilot hotkeys`

## 获取帮助

如果以上步骤都无法解决问题：

1. **运行诊断工具**:
   ```bash
   ./diagnose.sh > diagnostic_report.txt
   ```

2. **收集系统信息**:
   ```bash
   echo "OS: $(uname -a)" > system_info.txt
   echo "Bash: $BASH_VERSION" >> system_info.txt
   echo "Python: $(python3 --version)" >> system_info.txt
   echo "Terminal: $TERM" >> system_info.txt
   ```

3. **在 GitHub 提交 issue**，并附上：
   - diagnostic_report.txt
   - system_info.txt
   - 你尝试过的步骤
   - 错误信息截图

## 常用命令参考

```bash
# 查看帮助
bash-copilot --help

# 查看可用快捷键
bash-copilot hotkeys

# 测试配置
bash-copilot config

# 测试完成功能
echo "list files" | bash-copilot complete

# 重新加载配置
source ~/.bashrc

# 检查环境
./diagnose.sh

# 手动触发完成
_bash_copilot_complete
```

## 性能优化建议

如果工具可用但响应慢：

```bash
# 1. 使用更快的模型
bash-copilot config --model gpt-3.5-turbo

# 2. 使用地理位置更近的 API 端点（如果可用）

# 3. 检查网络延迟
ping api.openai.com

# 4. 考虑使用本地模型
bash-copilot config --base-uri http://localhost:1234/v1
```

---

**需要更多帮助？** 访问项目 GitHub 或查看其他文档文件（README.md、HOTKEYS.md、EXAMPLES.md）。
