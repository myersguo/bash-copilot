# Contributing to Bash Copilot

Thank you for your interest in contributing to Bash Copilot! This document provides guidelines and instructions for contributing.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/yourusername/bash-copilot.git`
3. Create a feature branch: `git checkout -b feature/my-new-feature`
4. Make your changes
5. Test your changes thoroughly
6. Commit your changes: `git commit -am 'Add some feature'`
7. Push to the branch: `git push origin feature/my-new-feature`
8. Create a Pull Request

## Development Setup

### Prerequisites

- Python 3.6 or higher
- Bash shell
- Git

### Local Development

```bash
# Clone the repository
git clone https://github.com/yourusername/bash-copilot.git
cd bash-copilot

# Make scripts executable
chmod +x bash_copilot.py
chmod +x bash_copilot_completion.sh
chmod +x install.sh

# Test the main script
python3 bash_copilot.py --help
```

## Code Style

- Follow PEP 8 for Python code
- Use meaningful variable and function names
- Add docstrings to functions and classes
- Keep functions small and focused
- Add comments for complex logic

## Testing

Before submitting a PR, please test:

1. **Basic functionality**:
   ```bash
   python3 bash_copilot.py config --api-key test-key
   python3 bash_copilot.py complete "list files"
   ```

2. **Installation**:
   ```bash
   ./install.sh
   ```

3. **Shell integration**:
   - Test the hotkey (Ctrl+Space)
   - Test with various command types
   - Test error handling

## Pull Request Guidelines

- **Title**: Use a clear, descriptive title
- **Description**: Explain what changes you made and why
- **Testing**: Describe how you tested your changes
- **Documentation**: Update README.md if needed
- **Commits**: Use clear commit messages

### Commit Message Format

```
type: brief description

Detailed explanation of changes (if needed)
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

Examples:
```
feat: add support for custom timeout configuration

fix: handle network errors gracefully

docs: update installation instructions for macOS
```

## Feature Requests and Bug Reports

### Reporting Bugs

Please include:
- Description of the bug
- Steps to reproduce
- Expected behavior
- Actual behavior
- Environment (OS, Python version, bash version)
- Error messages or logs

### Suggesting Features

Please include:
- Clear description of the feature
- Use cases and benefits
- Possible implementation approach (if you have ideas)

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Focus on constructive feedback
- Respect different viewpoints

## Areas for Contribution

We welcome contributions in these areas:

### Features
- Support for more AI providers
- Enhanced context awareness
- Command history integration
- Multi-language support (zsh, fish, etc.)
- Caching for faster responses
- Offline mode with local models

### Documentation
- Improve README
- Add usage examples
- Create video tutorials
- Translate documentation

### Testing
- Add unit tests
- Add integration tests
- Test on different platforms
- Test with various AI models

### Bug Fixes
- Fix reported issues
- Improve error handling
- Performance optimizations

## Questions?

If you have questions:
- Open an issue with the "question" label
- Check existing issues and discussions
- Review the README and documentation

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

Thank you for contributing to Bash Copilot! 🚀
