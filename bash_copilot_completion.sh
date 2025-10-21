#!/bin/bash
# Bash Copilot completion script
# This script provides AI-powered command completion using OpenAI

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASH_COPILOT_BIN="${SCRIPT_DIR}/bash_copilot.py"

# Function to convert preset name to key binding
# This uses case statement for compatibility with older bash versions
_get_hotkey_binding() {
    local preset="$1"
    case "$preset" in
        ctrl-space)
            echo "\C-@"
            ;;
        ctrl-g)
            echo "\C-g"
            ;;
        ctrl-p)
            echo "\C-p"
            ;;
        ctrl-o)
            echo "\C-o"
            ;;
        ctrl-k)
            echo "\C-k"
            ;;
        alt-c)
            echo "\ec"
            ;;
        alt-a)
            echo "\ea"
            ;;
        alt-s)
            echo "\es"
            ;;
        alt-space)
            echo "\e "
            ;;
        f2)
            echo "\eOP"
            ;;
        f3)
            echo "\eOQ"
            ;;
        f4)
            echo "\eOR"
            ;;
        *)
            # Return empty if not a known preset
            echo ""
            ;;
    esac
}

# Determine the key binding to use
if [ -n "${BASH_COPILOT_HOTKEY}" ]; then
    # Try to get preset binding
    PRESET_BINDING=$(_get_hotkey_binding "${BASH_COPILOT_HOTKEY}")

    if [ -n "$PRESET_BINDING" ]; then
        # It's a known preset
        BASH_COPILOT_KEY="$PRESET_BINDING"
        BASH_COPILOT_KEY_DISPLAY="${BASH_COPILOT_HOTKEY}"
    else
        # Assume it's a custom binding sequence
        BASH_COPILOT_KEY="${BASH_COPILOT_HOTKEY}"
        BASH_COPILOT_KEY_DISPLAY="custom (${BASH_COPILOT_HOTKEY})"
    fi
elif [ -n "${BASH_COPILOT_KEY}" ]; then
    # Legacy: Support old BASH_COPILOT_KEY variable for backward compatibility
    BASH_COPILOT_KEY_DISPLAY="custom (${BASH_COPILOT_KEY})"
else
    # Default to Ctrl+Space
    BASH_COPILOT_KEY="\C-@"
    BASH_COPILOT_KEY_DISPLAY="ctrl-space"
fi

# Function to get AI-powered command completion
_bash_copilot_complete() {
    local current_line="${READLINE_LINE}"

    # Skip if line is empty
    if [[ -z "$current_line" ]]; then
        return
    fi

    # Show thinking indicator
    echo -ne "\r\033[K🤔 Getting AI suggestion..."

    # Call the Python script to get completion
    local completion
    completion=$(echo "$current_line" | python3 "$BASH_COPILOT_BIN" complete --context 2>/dev/null)

    # Clear the thinking indicator
    echo -ne "\r\033[K"

    if [[ -n "$completion" ]]; then
        # Replace current line with completion
        READLINE_LINE="$completion"
        READLINE_POINT=${#READLINE_LINE}
    else
        # If completion failed, just restore the original line
        echo -ne "\rError: Failed to get completion\r"
        sleep 1
        echo -ne "\r\033[K"
    fi
}

# Bind the key to our completion function
bind -x "\"${BASH_COPILOT_KEY}\": _bash_copilot_complete"

# Show information on first load
if [[ -z "${BASH_COPILOT_LOADED}" ]]; then
    export BASH_COPILOT_LOADED=1
    echo "🚀 Bash Copilot loaded! Hotkey: ${BASH_COPILOT_KEY_DISPLAY}"
    echo "   Configure with: bash-copilot config"
    echo "   Change hotkey with: export BASH_COPILOT_HOTKEY=<preset>"
    echo "   List hotkeys with: bash-copilot hotkeys"
fi
