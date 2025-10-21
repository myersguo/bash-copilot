#!/bin/bash
# Mac Hotkey Tester
# This script helps test which hotkeys work on macOS

echo "========================================="
echo "  Bash Copilot - Mac Hotkey Tester"
echo "========================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Testing hotkey bindings on macOS...${NC}"
echo ""

# Test function
test_hotkey() {
    local name="$1"
    local binding="$2"
    local display="$3"

    # Create a temporary test function
    _test_fn() {
        echo "✓ $display works!"
    }

    # Try to bind it
    if bind -x "\"$binding\": _test_fn" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} $name ($display) - binding created successfully"
        echo "   Try pressing: $display"

        # Check if it's actually bound
        if bind -P 2>/dev/null | grep -q "_test_fn"; then
            echo -e "${GREEN}  Binding confirmed in readline${NC}"
        fi
    else
        echo -e "${RED}✗${NC} $name ($display) - failed to bind"
    fi

    # Unbind
    bind -r "$binding" 2>/dev/null
    echo ""
}

echo "1. Testing Ctrl key combinations:"
echo "-----------------------------------"
test_hotkey "ctrl-space" "\C-@" "Ctrl+Space"
test_hotkey "ctrl-g" "\C-g" "Ctrl+G"
test_hotkey "ctrl-o" "\C-o" "Ctrl+O"
test_hotkey "ctrl-p" "\C-p" "Ctrl+P"
test_hotkey "ctrl-k" "\C-k" "Ctrl+K"
test_hotkey "ctrl-x" "\C-x" "Ctrl+X"

echo "2. Testing Alt/Option key combinations:"
echo "----------------------------------------"
test_hotkey "alt-c" "\ec" "Alt+C"
test_hotkey "alt-a" "\ea" "Alt+A"
test_hotkey "alt-s" "\es" "Alt+S"
test_hotkey "alt-space" "\e " "Alt+Space"

echo "3. Testing Function keys:"
echo "-------------------------"
test_hotkey "f2" "\eOP" "F2"
test_hotkey "f3" "\eOQ" "F3"
test_hotkey "f4" "\eOR" "F4"

echo ""
echo "========================================="
echo "  Current Environment"
echo "========================================="
echo "Terminal: $TERM"
echo "Bash version: $BASH_VERSION"
echo "Current BASH_COPILOT_HOTKEY: ${BASH_COPILOT_HOTKEY:-not set}"
echo ""

echo "========================================="
echo "  Interactive Test"
echo "========================================="
echo ""
echo "Now let's test your current hotkey interactively..."
echo ""

# Load the actual completion script if available
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/bash_copilot_completion.sh" ]; then
    echo "Loading bash_copilot_completion.sh..."
    source "${SCRIPT_DIR}/bash_copilot_completion.sh"
    echo ""
    echo -e "${YELLOW}Current hotkey is set to: ${BASH_COPILOT_KEY_DISPLAY}${NC}"
    echo ""
    echo "Try typing something and pressing your hotkey:"
    echo "(Press Ctrl+C to exit)"
    echo ""

    # Show what binding is active
    echo "Active binding:"
    bind -P | grep bash_copilot || echo "  No bash_copilot binding found!"
    echo ""
else
    echo -e "${RED}Error: bash_copilot_completion.sh not found${NC}"
fi

echo ""
echo "========================================="
echo "  Recommendations for macOS"
echo "========================================="
echo ""
echo "⭐ Best working hotkeys on macOS:"
echo ""
echo "1. ${GREEN}Ctrl+G${NC} (ctrl-g) - Usually works everywhere"
echo "   export BASH_COPILOT_HOTKEY=ctrl-g"
echo ""
echo "2. ${GREEN}Alt+C${NC} (alt-c) - Works if Option is set as Meta"
echo "   Terminal > Preferences > Profiles > Keyboard"
echo "   Check: 'Use Option as Meta key'"
echo "   export BASH_COPILOT_HOTKEY=alt-c"
echo ""
echo "3. ${GREEN}F2${NC} (f2) - Most reliable, no conflicts"
echo "   export BASH_COPILOT_HOTKEY=f2"
echo ""
echo "4. ${YELLOW}Ctrl+O${NC} (ctrl-o) - May be captured by Terminal.app"
echo "   or used for 'accept-line-and-down-history'"
echo ""
echo "To apply changes:"
echo "  1. Add to ~/.bashrc or ~/.bash_profile:"
echo "     export BASH_COPILOT_HOTKEY=ctrl-g"
echo "  2. Reload: source ~/.bashrc"
echo ""
