# Bash Copilot Hotkey Configuration Guide

This guide explains how to configure and customize the hotkey used to trigger Bash Copilot's AI-powered command completion.

## Quick Start

To view all available hotkey presets:
```bash
bash-copilot hotkeys
```

## Default Hotkey

By default, Bash Copilot uses **Ctrl+Space** to trigger command completion.

## Available Preset Hotkeys

Bash Copilot comes with several predefined hotkey combinations you can choose from:

| Preset Name | Keys | Description | Notes |
|-------------|------|-------------|-------|
| `ctrl-space` | Ctrl+Space | Default hotkey | May conflict with some terminals |
| `ctrl-g` | Ctrl+G | Good alternative | Usually available |
| `ctrl-p` | Ctrl+P | IDE-style autocomplete | Similar to VS Code |
| `ctrl-o` | Ctrl+O | Alternative Ctrl key | May conflict with terminal features |
| `ctrl-k` | Ctrl+K | Vim-style | May conflict in Vim mode |
| `alt-c` | Alt+C | Alt key variant | Works well in most terminals |
| `alt-a` | Alt+A | Alt key variant | Usually available |
| `alt-s` | Alt+S | Alt key variant | Usually available |
| `alt-space` | Alt+Space | Alt+Space combo | May conflict with window manager |
| `f2` | F2 | Function key | Easy to remember |
| `f3` | F3 | Function key | Easy to remember |
| `f4` | F4 | Function key | Easy to remember |

## How to Change Hotkey

### Method 1: Using a Preset (Recommended)

1. Add the following line to your `~/.bashrc`:
   ```bash
   export BASH_COPILOT_HOTKEY=ctrl-g
   ```

2. Reload your shell configuration:
   ```bash
   source ~/.bashrc
   ```

3. The new hotkey is now active!

### Method 2: Using a Custom Binding

For advanced users who want to use a specific key combination not in the presets:

1. Add a custom binding to your `~/.bashrc`:
   ```bash
   # For Ctrl+X
   export BASH_COPILOT_HOTKEY='\C-x'

   # For Alt+X
   export BASH_COPILOT_HOTKEY='\ex'

   # For Ctrl+] (custom example)
   export BASH_COPILOT_HOTKEY='\C-]'
   ```

2. Reload your shell:
   ```bash
   source ~/.bashrc
   ```

## Key Binding Sequences Reference

When creating custom bindings, use these sequences:

### Control Keys
- `\C-a` through `\C-z` = Ctrl+A through Ctrl+Z
- `\C-@` = Ctrl+Space
- `\C-]` = Ctrl+]
- `\C-\\` = Ctrl+\

### Alt/Meta Keys
- `\ea` through `\ez` = Alt+A through Alt+Z (or Esc followed by the letter)
- `\e ` = Alt+Space
- `\e-` = Alt+-

### Function Keys
- `\eOP` = F2
- `\eOQ` = F3
- `\eOR` = F4
- Note: F1, F5+ may have different escape sequences depending on your terminal

### Special Keys
- `\e[A` = Up Arrow (not recommended for this use)
- `\e[B` = Down Arrow (not recommended for this use)
- `\e[C` = Right Arrow (not recommended for this use)
- `\e[D` = Left Arrow (not recommended for this use)

## Recommended Hotkeys by Use Case

### If Ctrl+Space conflicts with your terminal
Try one of these alternatives:
- `ctrl-g` - Good general purpose alternative
- `alt-c` - Easy to press with one hand
- `f2` - Simple and memorable

### If you use Vim mode in bash
Avoid these:
- `ctrl-p` (conflicts with previous command in Vim)
- `ctrl-k` (conflicts with delete line in Vim)

Instead try:
- `ctrl-g`
- `alt-a`
- `f2`

### If you use tmux
Avoid:
- Keys that conflict with your tmux prefix

Try:
- `alt-c` - Usually doesn't conflict
- `f2` or `f3` - Function keys work well with tmux

### If you use a tiling window manager
Avoid:
- `alt-space` - Often used by window managers
- Other Alt combinations that might be mapped

Try:
- `ctrl-g`
- `f2`

## Configuration Examples

### Example 1: Simple preset change
```bash
# In ~/.bashrc
export BASH_COPILOT_HOTKEY=ctrl-g
```

### Example 2: Multiple profile configurations
```bash
# In ~/.bashrc

# Use different hotkey based on hostname
if [[ $(hostname) == "workstation" ]]; then
    export BASH_COPILOT_HOTKEY=ctrl-g
else
    export BASH_COPILOT_HOTKEY=alt-c
fi
```

### Example 3: Conditional with tmux
```bash
# In ~/.bashrc

# Use F2 inside tmux, Ctrl+G outside
if [[ -n "$TMUX" ]]; then
    export BASH_COPILOT_HOTKEY=f2
else
    export BASH_COPILOT_HOTKEY=ctrl-g
fi
```

## Checking Your Current Hotkey

To see which hotkey is currently configured:

1. Reload your shell to see the startup message:
   ```bash
   source ~/.bashrc
   ```

   You should see: `🚀 Bash Copilot loaded! Hotkey: ctrl-space`

2. Or run:
   ```bash
   echo $BASH_COPILOT_HOTKEY
   ```

3. Or use the hotkeys command:
   ```bash
   bash-copilot hotkeys
   ```

## Troubleshooting

### Hotkey not working after changing

1. Make sure you've reloaded your shell:
   ```bash
   source ~/.bashrc
   ```

2. Check if the environment variable is set:
   ```bash
   echo $BASH_COPILOT_HOTKEY
   ```

3. Try a different hotkey that's less likely to conflict

### Hotkey conflicts with another program

1. Use the `bash-copilot hotkeys` command to see alternatives
2. Choose a hotkey that's not commonly used
3. Function keys (F2, F3, F4) are usually safe choices

### Custom binding not working

1. Make sure you're using the correct escape sequence syntax
2. Ensure quotes are properly escaped in your `.bashrc`
3. Test with a preset first to ensure the system is working
4. Check readline documentation: `man readline`

## Testing Bindings

To test if a key binding is available:

1. Type the key combination in your terminal
2. If nothing happens or you see escape sequences, it's likely available
3. If it triggers an action, that key is already bound and may conflict

You can also check current bindings:
```bash
bind -P | grep -i "complete\|copilot"
```

## Advanced: Multiple Hotkeys

If you want multiple hotkeys to trigger the same function, you can add additional bindings:

Create a custom script `~/.bash_copilot_custom.sh`:
```bash
# Load the default completion
source /path/to/bash_copilot_completion.sh

# Add additional bindings
bind -x '"\eg": _bash_copilot_complete'  # Add Ctrl+G
bind -x '"\eOP": _bash_copilot_complete'  # Add F2
```

Then source this custom script in your `~/.bashrc` instead.

## Legacy Support

For backward compatibility, Bash Copilot also supports the old `BASH_COPILOT_KEY` environment variable:

```bash
# This still works but is deprecated
export BASH_COPILOT_KEY='\C-g'
```

We recommend using `BASH_COPILOT_HOTKEY` with preset names instead.

## Getting Help

If you need help with hotkey configuration:

1. Run `bash-copilot hotkeys` to see all options
2. Check this documentation
3. Open an issue on GitHub with your configuration

## Summary

- **Default**: Ctrl+Space
- **View options**: `bash-copilot hotkeys`
- **Change hotkey**: Add `export BASH_COPILOT_HOTKEY=<preset>` to `~/.bashrc`
- **Reload**: `source ~/.bashrc`
- **Recommended alternatives**: `ctrl-g`, `alt-c`, or `f2`

Happy command completing! 🚀
