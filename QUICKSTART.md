# Bash Copilot 快速开始指南

这是一个快速开始和故障排除指南，帮助你在 5 分钟内运行 Bash Copilot。

## 立即开始 (3 步)

### 1. 安装
```bash
cd /path/to/bash-copilot
./install.sh
```

### 2. 配置 API Key
```bash
bash-copilot config --api-key YOUR_OPENAI_API_KEY
```

### 3. 加载并使用
```bash
source ~/.bashrc
# 现在输入一些文本，然后按 Ctrl+Space
```

## 快捷键不生效？快速诊断

### 一键诊断
```bash
cd /path/to/bash-copilot
./diagnose.sh
```

### 手动排查（按顺序尝试）

#### 步骤 1: 重新加载配置
```bash
source ~/.bashrc
```
**90% 的问题通过这一步解决！**

#### 步骤 2: 检查是否加载
```bash
echo $BASH_COPILOT_LOADED
```
如果输出 `1`，说明已加载。如果为空，继续下一步。

#### 步骤 3: 检查 .bashrc
```bash
grep bash_copilot ~/.bashrc
```
如果没有输出，运行：
```bash
bash-copilot install
source ~/.bashrc
```

#### 步骤 4: 更换快捷键
某些终端不支持 Ctrl+Space，试试其他的：
```bash
export BASH_COPILOT_HOTKEY=ctrl-g
source ~/.bashrc
```

或使用功能键（最保险）：
```bash
export BASH_COPILOT_HOTKEY=f2
source ~/.bashrc
```

#### 步骤 5: 测试基本功能
```bash
echo "list files" | bash-copilot complete
```
如果这个有效，说明是快捷键问题，继续调整快捷键。
如果这个失败，说明是 API 配置问题。

## 常见错误速查

### 错误: "command not found: bash-copilot"
```bash
# 方法 1: 创建软链接
sudo ln -s $(pwd)/bash_copilot.py /usr/local/bin/bash-copilot

# 方法 2: 使用完整路径
python3 /path/to/bash-copilot/bash_copilot.py config
```

### 错误: "Error: OpenAI API key not configured"
```bash
bash-copilot config --api-key sk-your-api-key-here
```

### 错误: "declare: -A: invalid option"
这个错误已经修复。重新加载脚本：
```bash
source ~/.bashrc
```

如果还有问题，确保你使用的是修复后的版本：
```bash
cd /path/to/bash-copilot
git pull
source ~/.bashrc
```

### 错误: "Failed to get completion"
检查网络和 API key：
```bash
# 测试 API 连接
curl https://api.openai.com/v1/models \
  -H "Authorization: Bearer YOUR_API_KEY"

# 重新配置
bash-copilot config
```

## 按终端类型配置

### macOS Terminal
```bash
# 在 Terminal > Preferences > Profiles > Keyboard
# 勾选 "Use Option as Meta key"
export BASH_COPILOT_HOTKEY=alt-c
source ~/.bashrc
```

### iTerm2
```bash
# Ctrl+Space 可能被占用
export BASH_COPILOT_HOTKEY=ctrl-g
source ~/.bashrc
```

### Windows Terminal / WSL
```bash
export BASH_COPILOT_HOTKEY=alt-c
source ~/.bashrc
```

### Tmux 用户
```bash
# 功能键不会被 tmux 拦截
export BASH_COPILOT_HOTKEY=f2
source ~/.bashrc
```

### SSH 远程连接
```bash
# 使用最通用的快捷键
export BASH_COPILOT_HOTKEY=f2
source ~/.bashrc
```

## 查看所有可用快捷键

```bash
bash-copilot hotkeys
```

输出示例：
```
Available Hotkey Presets:
------------------------------------------------------------
Preset Name     Keys                 Description
------------------------------------------------------------
ctrl-space      Ctrl+Space           Default hotkey
ctrl-g          Ctrl+G               Good alternative
ctrl-p          Ctrl+P               Similar to IDE autocomplete
alt-c           Alt+C                Alt key variant
f2              F2                   Function key
...
```

## 推荐配置

### 最通用配置（推荐新手）
```bash
# 添加到 ~/.bashrc
export BASH_COPILOT_HOTKEY=f2

# 重新加载
source ~/.bashrc
```

### 程序员友好配置
```bash
export BASH_COPILOT_HOTKEY=ctrl-g
```

### Vim 用户配置
```bash
export BASH_COPILOT_HOTKEY=alt-c
```

## 使用示例

### 文件操作
```
你输入: find large files
按 [快捷键]
得到: find . -type f -size +100M
```

### 系统管理
```
你输入: show disk usage
按 [快捷键]
得到: df -h
```

### Git 操作
```
你输入: show git log with graph
按 [快捷键]
得到: git log --graph --oneline --all
```

### Docker
```
你输入: stop all containers
按 [快捷键]
得到: docker stop $(docker ps -q)
```

## 性能优化

### 使用更快的模型
```bash
bash-copilot config --model gpt-3.5-turbo
```

### 使用本地模型（无需网络）
```bash
# 假设你运行了本地 LLM（如 LM Studio）
bash-copilot config --base-uri http://localhost:1234/v1
bash-copilot config --model local-model
```

## 高级配置

### 按环境使用不同快捷键
在 `~/.bashrc` 中添加：
```bash
if [[ -n "$TMUX" ]]; then
    # 在 tmux 中使用 F2
    export BASH_COPILOT_HOTKEY=f2
else
    # 普通终端使用 Ctrl+G
    export BASH_COPILOT_HOTKEY=ctrl-g
fi
```

### 使用多个快捷键
创建 `~/.bash_copilot_custom.sh`:
```bash
# 加载默认配置
source /path/to/bash_copilot_completion.sh

# 添加额外的快捷键绑定
bind -x '"\C-g": _bash_copilot_complete'  # Ctrl+G
bind -x '"\eOP": _bash_copilot_complete'  # F2
```

然后在 `~/.bashrc` 中 source 这个自定义脚本。

## 完全卸载

如果需要移除 Bash Copilot：
```bash
# 1. 从 .bashrc 移除
sed -i.bak '/bash_copilot/d' ~/.bashrc

# 2. 删除配置文件
rm ~/.bash-copilot.json

# 3. 删除软链接（如果创建了）
sudo rm /usr/local/bin/bash-copilot

# 4. 重新加载
source ~/.bashrc
```

## 获取帮助

### 文档
- `README.md` - 完整文档
- `HOTKEYS.md` - 快捷键详细说明
- `TROUBLESHOOTING.md` - 详细故障排除
- `EXAMPLES.md` - 使用示例

### 命令
```bash
bash-copilot --help        # 帮助信息
bash-copilot hotkeys       # 查看快捷键
./diagnose.sh              # 诊断问题
```

### 报告问题
1. 运行诊断工具: `./diagnose.sh > report.txt`
2. 在 GitHub 提交 issue，附上 report.txt

## 常见问题 FAQ

**Q: 可以离线使用吗？**
A: 可以，配置本地 LLM 即可。

**Q: 支持其他 shell 吗？**
A: 目前只支持 bash，zsh 支持正在开发中。

**Q: API 调用会很贵吗？**
A: 使用 gpt-3.5-turbo 很便宜，每次调用约 $0.0001-0.0002。

**Q: 安全吗？**
A: API key 存储在本地 ~/.bash-copilot.json，不会发送到除 OpenAI 外的其他地方。

**Q: 可以自定义提示词吗？**
A: 目前不支持，但可以通过修改 bash_copilot.py 中的 system prompt 实现。

---

**需要更多帮助？** 运行 `./diagnose.sh` 或查看 TROUBLESHOOTING.md
