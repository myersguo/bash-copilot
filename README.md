# Bash Copilot

🚀 AI-powered bash command completion using OpenAI

Bash Copilot brings the power of AI to your command line, helping you write bash commands faster and more accurately. Simply describe what you want to do in natural language, press a hotkey, and get the complete bash command instantly.

## Features

- 🤖 **AI-Powered Completions**: Leverages OpenAI's language models to understand your intent
- ⚙️ **Configurable**: Support for custom OpenAI API endpoints, keys, and models
- ⌨️ **Simple Hotkey**: Press `Ctrl+Space` to get instant command suggestions
- 🔧 **Zero Dependencies**: Uses only Python standard library
- 🎯 **Context-Aware**: Understands your current working directory and environment
- 🔒 **Secure**: API keys stored locally in your home directory

## Requirements

- Python 3.6+
- Bash shell
- OpenAI API key (or compatible API endpoint)

## Installation

### Quick Install

```bash
git clone https://github.com/yourusername/bash-copilot.git
cd bash-copilot
chmod +x install.sh
./install.sh
```

### Manual Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/bash-copilot.git
cd bash-copilot
```

2. Make scripts executable:
```bash
chmod +x bash_copilot.py
chmod +x bash_copilot_completion.sh
```

3. Add to your `.bashrc`:
```bash
echo 'source /path/to/bash-copilot/bash_copilot_completion.sh' >> ~/.bashrc
```

4. Reload your shell:
```bash
source ~/.bashrc
```

## Configuration

### First Time Setup

Run the configuration wizard:

```bash
bash-copilot config
```

You'll be prompted to enter:
- **API Key**: Your OpenAI API key
- **Base URI**: API endpoint (default: `https://api.openai.com/v1`)
- **Model**: Model name (default: `gpt-3.5-turbo`)

### Command Line Configuration

You can also configure directly from the command line:

```bash
# Set API key
bash-copilot config --api-key sk-your-api-key-here

# Set custom API endpoint
bash-copilot config --base-uri https://api.openai.com/v1

# Set model
bash-copilot config --model gpt-4
```

### Configuration File

Configuration is stored in `~/.bash-copilot.json`:

```json
{
  "api_key": "sk-your-api-key",
  "base_uri": "https://api.openai.com/v1",
  "model": "gpt-3.5-turbo"
}
```

You can also use environment variables:
```bash
export OPENAI_API_KEY="sk-your-api-key"
```

## Usage

### Interactive Mode (Recommended)

1. Type a natural language description or partial command:
   ```
   list all pdf files in current directory
   ```

2. Press `Ctrl+Space`

3. The command is automatically completed:
   ```bash
   find . -maxdepth 1 -name "*.pdf"
   ```

### Examples

| What you type | Press Ctrl+Space | You get |
|---------------|------------------|---------|
| `find large files` | `Ctrl+Space` | `find . -type f -size +100M` |
| `show disk usage` | `Ctrl+Space` | `df -h` |
| `compress folder to tar.gz` | `Ctrl+Space` | `tar -czf archive.tar.gz folder/` |
| `find all python files modified today` | `Ctrl+Space` | `find . -name "*.py" -mtime 0` |
| `show listening ports` | `Ctrl+Space` | `netstat -tuln \| grep LISTEN` |

### Command Line Mode

You can also use Bash Copilot directly from the command line:

```bash
# Get completion for a command
bash-copilot complete "list all processes using port 8080"

# With context (includes current directory info)
bash-copilot complete --context "find all large log files"

# Pipe input
echo "compress all images" | bash-copilot complete
```

## Customization

### Change Hotkey

By default, `Ctrl+Space` triggers the completion. To change it, set the `BASH_COPILOT_KEY` environment variable in your `.bashrc`:

```bash
# Use Ctrl+P instead
export BASH_COPILOT_KEY="\C-p"

# Use Alt+C
export BASH_COPILOT_KEY="\e-c"
```

### Using Different API Providers

Bash Copilot works with any OpenAI-compatible API:

```bash
# Azure OpenAI
bash-copilot config --base-uri https://your-resource.openai.azure.com/openai/deployments/your-deployment

# Local models (e.g., LM Studio, Ollama with OpenAI compatibility)
bash-copilot config --base-uri http://localhost:1234/v1

# Other OpenAI-compatible providers
bash-copilot config --base-uri https://api.your-provider.com/v1
```

## Advanced Usage

### Using with Different Models

```bash
# Use GPT-4 for better quality
bash-copilot config --model gpt-4

# Use GPT-3.5-turbo for faster/cheaper responses
bash-copilot config --model gpt-3.5-turbo

# Use custom models
bash-copilot config --model custom-model-name
```

### Scripting

You can use Bash Copilot in scripts:

```bash
#!/bin/bash

# Get AI-generated command
COMMAND=$(bash-copilot complete "find files larger than 1GB")

# Review before executing
echo "Will execute: $COMMAND"
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    eval "$COMMAND"
fi
```

## Troubleshooting

### Command not found: bash-copilot

Make sure the symlink was created:
```bash
sudo ln -s /path/to/bash-copilot/bash_copilot.py /usr/local/bin/bash-copilot
```

Or use the full path:
```bash
python3 /path/to/bash-copilot/bash_copilot.py config
```

### API key not configured

Run the configuration:
```bash
bash-copilot config --api-key sk-your-api-key
```

Or set environment variable:
```bash
export OPENAI_API_KEY="sk-your-api-key"
```

### Hotkey not working

1. Make sure you've reloaded your shell: `source ~/.bashrc`
2. Check if the completion script is loaded: `echo $BASH_COPILOT_LOADED`
3. Try a different hotkey combination

### Network errors

- Check your internet connection
- Verify the base URI is correct
- Ensure your API key is valid
- Check if you have quota remaining on your OpenAI account

## Security Considerations

- **API Keys**: Never commit your config file to version control
- **Command Review**: Always review AI-generated commands before executing
- **Sensitive Data**: Be cautious about sharing command history that may contain sensitive information

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see LICENSE file for details

## Acknowledgments

- Built with OpenAI's GPT models
- Inspired by GitHub Copilot and other AI coding assistants

## Support

If you encounter any issues or have questions:
- Open an issue on GitHub
- Check existing issues for solutions
- Review the troubleshooting section above

---

Made with ❤️ for the command line
