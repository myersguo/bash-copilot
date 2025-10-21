#!/bin/bash
# Bash Copilot completion script
# This script provides AI-powered command completion using OpenAI

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASH_COPILOT_BIN="${SCRIPT_DIR}/bash_copilot.py"

# Key binding for AI completion (Ctrl+Space by default)
# You can change this by setting BASH_COPILOT_KEY environment variable
BASH_COPILOT_KEY="${BASH_COPILOT_KEY:-\C-@}"

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
    echo "🚀 Bash Copilot loaded! Press Ctrl+Space for AI-powered command completion."
    echo "   Configure with: python3 ${BASH_COPILOT_BIN} config"
fi
