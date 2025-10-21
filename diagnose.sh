#!/bin/bash
# Bash Copilot Diagnostic Tool
# This script helps diagnose why the hotkey is not working

echo "========================================="
echo "  Bash Copilot Diagnostic Tool"
echo "========================================="
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print status
print_check() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $2"
    else
        echo -e "${RED}✗${NC} $2"
    fi
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Check 1: Python version
echo "1. Checking Python installation..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1)
    print_check 0 "Python 3 found: $PYTHON_VERSION"
else
    print_check 1 "Python 3 not found"
    echo "   Install Python 3 to use Bash Copilot"
fi
echo ""

# Check 2: Script location
echo "2. Checking script files..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAIN_SCRIPT="${SCRIPT_DIR}/bash_copilot.py"
COMPLETION_SCRIPT="${SCRIPT_DIR}/bash_copilot_completion.sh"

if [ -f "$MAIN_SCRIPT" ]; then
    print_check 0 "Main script found: $MAIN_SCRIPT"
else
    print_check 1 "Main script not found at: $MAIN_SCRIPT"
fi

if [ -f "$COMPLETION_SCRIPT" ]; then
    print_check 0 "Completion script found: $COMPLETION_SCRIPT"
else
    print_check 1 "Completion script not found at: $COMPLETION_SCRIPT"
fi

if [ -x "$MAIN_SCRIPT" ]; then
    print_check 0 "Main script is executable"
else
    print_check 1 "Main script is not executable"
    echo "   Run: chmod +x $MAIN_SCRIPT"
fi

if [ -x "$COMPLETION_SCRIPT" ]; then
    print_check 0 "Completion script is executable"
else
    print_check 1 "Completion script is not executable"
    echo "   Run: chmod +x $COMPLETION_SCRIPT"
fi
echo ""

# Check 3: Configuration
echo "3. Checking configuration..."
CONFIG_FILE="${HOME}/.bash-copilot.json"
if [ -f "$CONFIG_FILE" ]; then
    print_check 0 "Config file found: $CONFIG_FILE"

    # Check if API key is set
    if grep -q "api_key" "$CONFIG_FILE" 2>/dev/null; then
        API_KEY=$(python3 -c "import json; print(json.load(open('$CONFIG_FILE')).get('api_key', ''))" 2>/dev/null)
        if [ -n "$API_KEY" ] && [ "$API_KEY" != "null" ]; then
            print_check 0 "API key is configured"
        else
            print_check 1 "API key is not set in config file"
            echo "   Run: bash-copilot config --api-key YOUR_API_KEY"
        fi
    fi
else
    print_check 1 "Config file not found"
    echo "   Run: bash-copilot config"
fi

# Check environment variable
if [ -n "$OPENAI_API_KEY" ]; then
    print_check 0 "OPENAI_API_KEY environment variable is set"
else
    print_info "OPENAI_API_KEY environment variable is not set (optional)"
fi
echo ""

# Check 4: Bashrc integration
echo "4. Checking .bashrc integration..."
BASHRC="${HOME}/.bashrc"
if [ -f "$BASHRC" ]; then
    if grep -q "bash_copilot_completion.sh" "$BASHRC" 2>/dev/null; then
        print_check 0 ".bashrc sources the completion script"
    else
        print_check 1 ".bashrc does not source the completion script"
        echo "   Run: bash-copilot install"
        echo "   Or manually add: source \"$COMPLETION_SCRIPT\""
    fi
else
    print_check 1 ".bashrc not found"
fi
echo ""

# Check 5: Current shell environment
echo "5. Checking current shell environment..."
if [ -n "$BASH" ]; then
    print_check 0 "Running in bash: $BASH_VERSION"
else
    print_check 1 "Not running in bash"
    echo "   Bash Copilot requires bash shell"
fi

# Check if completion script is loaded
if [ -n "$BASH_COPILOT_LOADED" ]; then
    print_check 0 "Completion script is loaded in current session"
else
    print_check 1 "Completion script is NOT loaded in current session"
    echo "   Run: source ~/.bashrc"
    echo "   Or: source $COMPLETION_SCRIPT"
fi
echo ""

# Check 6: Hotkey configuration
echo "6. Checking hotkey configuration..."
if [ -n "$BASH_COPILOT_HOTKEY" ]; then
    print_info "BASH_COPILOT_HOTKEY is set to: $BASH_COPILOT_HOTKEY"
elif [ -n "$BASH_COPILOT_KEY" ]; then
    print_info "BASH_COPILOT_KEY (legacy) is set to: $BASH_COPILOT_KEY"
else
    print_info "Using default hotkey: ctrl-space (Ctrl+Space)"
fi

# Show current readline bindings
echo ""
echo "Current bash-copilot related bindings:"
bind -P 2>/dev/null | grep -i "bash_copilot" || echo "   No bindings found"
echo ""

# Check 7: Test basic functionality
echo "7. Testing basic functionality..."
if [ -x "$MAIN_SCRIPT" ]; then
    TEST_OUTPUT=$(echo "list files" | python3 "$MAIN_SCRIPT" complete 2>&1)
    TEST_EXIT=$?

    if [ $TEST_EXIT -eq 0 ] && [ -n "$TEST_OUTPUT" ]; then
        print_check 0 "Basic completion test passed"
        print_info "Test output: $TEST_OUTPUT"
    else
        print_check 1 "Basic completion test failed"
        echo "   Error: $TEST_OUTPUT"
    fi
else
    print_warning "Skipping functionality test (script not executable)"
fi
echo ""

# Summary and recommendations
echo "========================================="
echo "  Summary and Recommendations"
echo "========================================="
echo ""

# Count issues
ISSUES=0

if ! command -v python3 &> /dev/null; then
    echo "❌ Install Python 3"
    ((ISSUES++))
fi

if [ ! -f "$MAIN_SCRIPT" ] || [ ! -f "$COMPLETION_SCRIPT" ]; then
    echo "❌ Reinstall Bash Copilot (missing files)"
    ((ISSUES++))
fi

if [ ! -x "$MAIN_SCRIPT" ] || [ ! -x "$COMPLETION_SCRIPT" ]; then
    echo "❌ Make scripts executable:"
    echo "   chmod +x $MAIN_SCRIPT $COMPLETION_SCRIPT"
    ((ISSUES++))
fi

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Configure Bash Copilot:"
    echo "   bash-copilot config"
    ((ISSUES++))
fi

if ! grep -q "bash_copilot_completion.sh" "$BASHRC" 2>/dev/null; then
    echo "❌ Install completion script to .bashrc:"
    echo "   bash-copilot install"
    ((ISSUES++))
fi

if [ -z "$BASH_COPILOT_LOADED" ]; then
    echo "⚠️  Reload your shell configuration:"
    echo "   source ~/.bashrc"
    echo "   Or restart your terminal"
    ((ISSUES++))
fi

if [ $ISSUES -eq 0 ]; then
    echo -e "${GREEN}✓ No major issues found!${NC}"
    echo ""
    echo "If the hotkey still doesn't work, try:"
    echo "  1. Check if your terminal supports the hotkey:"
    echo "     bash-copilot hotkeys"
    echo "  2. Try a different hotkey preset:"
    echo "     export BASH_COPILOT_HOTKEY=ctrl-g"
    echo "     source ~/.bashrc"
    echo "  3. Test the completion function manually:"
    echo "     Type a command, then run: _bash_copilot_complete"
else
    echo ""
    echo "Found $ISSUES issue(s) to fix. Please follow the recommendations above."
fi

echo ""
echo "========================================="
echo "  Quick Fix Commands"
echo "========================================="
echo ""
echo "# 1. Make scripts executable"
echo "chmod +x \"$MAIN_SCRIPT\" \"$COMPLETION_SCRIPT\""
echo ""
echo "# 2. Configure API key"
echo "bash-copilot config --api-key YOUR_API_KEY"
echo ""
echo "# 3. Install to .bashrc"
echo "bash-copilot install"
echo ""
echo "# 4. Reload configuration"
echo "source ~/.bashrc"
echo ""
echo "# 5. Test manually"
echo "echo 'list files' | bash-copilot complete"
echo ""
echo "For more help, see:"
echo "  - README.md"
echo "  - HOTKEYS.md"
echo "  - bash-copilot hotkeys"
echo ""
