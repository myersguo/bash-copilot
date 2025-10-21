#!/bin/bash
# Bash Copilot Installation Script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASH_COPILOT_BIN="${SCRIPT_DIR}/bash_copilot.py"
COMPLETION_SCRIPT="${SCRIPT_DIR}/bash_copilot_completion.sh"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Bash Copilot Installation${NC}"
echo -e "${BLUE}========================================${NC}"
echo

# Check Python 3
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Error: Python 3 is required but not installed.${NC}"
    exit 1
fi

PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
echo -e "${GREEN}✓${NC} Found Python ${PYTHON_VERSION}"

# Make scripts executable
chmod +x "$BASH_COPILOT_BIN"
chmod +x "$COMPLETION_SCRIPT"
echo -e "${GREEN}✓${NC} Made scripts executable"

# Add to bashrc
BASHRC="${HOME}/.bashrc"
SOURCE_LINE="source \"${COMPLETION_SCRIPT}\""

if grep -qF "$COMPLETION_SCRIPT" "$BASHRC" 2>/dev/null; then
    echo -e "${YELLOW}!${NC} Completion script already in ${BASHRC}"
else
    echo >> "$BASHRC"
    echo "# Bash Copilot - AI-powered command completion" >> "$BASHRC"
    echo "$SOURCE_LINE" >> "$BASHRC"
    echo -e "${GREEN}✓${NC} Added completion script to ${BASHRC}"
fi

# Create symlink in /usr/local/bin if possible
INSTALL_DIR="/usr/local/bin"
SYMLINK="${INSTALL_DIR}/bash-copilot"

if [[ -w "$INSTALL_DIR" ]]; then
    ln -sf "$BASH_COPILOT_BIN" "$SYMLINK"
    echo -e "${GREEN}✓${NC} Created symlink: ${SYMLINK}"
elif sudo -n true 2>/dev/null; then
    sudo ln -sf "$BASH_COPILOT_BIN" "$SYMLINK"
    echo -e "${GREEN}✓${NC} Created symlink: ${SYMLINK} (with sudo)"
else
    echo -e "${YELLOW}!${NC} Skipped creating symlink in ${INSTALL_DIR} (no permission)"
    echo -e "  You can run: sudo ln -s \"${BASH_COPILOT_BIN}\" \"${SYMLINK}\""
fi

echo
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}Installation complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo
echo "Next steps:"
echo -e "  1. Configure your OpenAI API key:"
echo -e "     ${YELLOW}bash-copilot config${NC}"
echo
echo -e "  2. Reload your shell:"
echo -e "     ${YELLOW}source ~/.bashrc${NC}"
echo
echo -e "  3. Start using it! Press ${YELLOW}Ctrl+Space${NC} to get AI suggestions"
echo
echo "Configuration options:"
echo -e "  • API Key:   Your OpenAI API key"
echo -e "  • Base URI:  Custom API endpoint (default: https://api.openai.com/v1)"
echo -e "  • Model:     Model to use (default: gpt-3.5-turbo)"
echo
echo "Example usage:"
echo -e "  • Type: ${YELLOW}list all pdf files${NC}"
echo -e "  • Press: ${YELLOW}Ctrl+Space${NC}"
echo -e "  • Get:   ${GREEN}find . -name \"*.pdf\"${NC}"
echo
