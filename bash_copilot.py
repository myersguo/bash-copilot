#!/usr/bin/env python3
"""
Bash Copilot - AI-powered bash command completion using OpenAI
"""

import os
import sys
import json
import argparse
from pathlib import Path
from typing import Optional, Dict, Any
import urllib.request
import urllib.error


class Config:
    """Configuration manager for Bash Copilot"""

    DEFAULT_CONFIG_PATH = os.path.expanduser("~/.bash-copilot.json")
    DEFAULT_MODEL = "gpt-3.5-turbo"
    DEFAULT_BASE_URI = "https://api.openai.com/v1"

    def __init__(self, config_path: Optional[str] = None):
        self.config_path = config_path or self.DEFAULT_CONFIG_PATH
        self.config = self._load_config()

    def _load_config(self) -> Dict[str, Any]:
        """Load configuration from file"""
        if os.path.exists(self.config_path):
            try:
                with open(self.config_path, 'r') as f:
                    return json.load(f)
            except (json.JSONDecodeError, IOError) as e:
                print(f"Warning: Failed to load config from {self.config_path}: {e}", file=sys.stderr)
                return {}
        return {}

    def save_config(self):
        """Save configuration to file"""
        try:
            os.makedirs(os.path.dirname(self.config_path), exist_ok=True)
            with open(self.config_path, 'w') as f:
                json.dump(self.config, f, indent=2)
            print(f"Configuration saved to {self.config_path}")
        except IOError as e:
            print(f"Error: Failed to save config to {self.config_path}: {e}", file=sys.stderr)
            sys.exit(1)

    def get(self, key: str, default: Any = None) -> Any:
        """Get configuration value"""
        return self.config.get(key, default)

    def set(self, key: str, value: Any):
        """Set configuration value"""
        self.config[key] = value

    @property
    def api_key(self) -> Optional[str]:
        """Get OpenAI API key from config or environment"""
        return self.config.get('api_key') or os.environ.get('OPENAI_API_KEY')

    @property
    def base_uri(self) -> str:
        """Get OpenAI base URI"""
        return self.config.get('base_uri', self.DEFAULT_BASE_URI)

    @property
    def model(self) -> str:
        """Get OpenAI model name"""
        return self.config.get('model', self.DEFAULT_MODEL)


class OpenAIClient:
    """OpenAI API client for chat completions"""

    def __init__(self, api_key: str, base_uri: str, model: str):
        self.api_key = api_key
        self.base_uri = base_uri.rstrip('/')
        self.model = model

    def complete(self, prompt: str, context: Optional[str] = None) -> str:
        """Get command completion from OpenAI"""

        messages = [
            {
                "role": "system",
                "content": "You are a bash command expert. Given a partial command or description, suggest the complete bash command. Only output the command itself, no explanations or markdown formatting."
            }
        ]

        if context:
            messages.append({
                "role": "user",
                "content": f"Current context:\nWorking directory: {os.getcwd()}\nShell environment: bash\n\nPartial command or request: {prompt}\n\nProvide only the complete bash command:"
            })
        else:
            messages.append({
                "role": "user",
                "content": f"Complete this bash command: {prompt}"
            })

        data = {
            "model": self.model,
            "messages": messages,
            "temperature": 0.3,
            "max_tokens": 200
        }

        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {self.api_key}"
        }

        try:
            request = urllib.request.Request(
                f"{self.base_uri}/chat/completions",
                data=json.dumps(data).encode('utf-8'),
                headers=headers,
                method='POST'
            )

            with urllib.request.urlopen(request, timeout=10) as response:
                result = json.loads(response.read().decode('utf-8'))
                completion = result['choices'][0]['message']['content'].strip()
                return completion

        except urllib.error.HTTPError as e:
            error_body = e.read().decode('utf-8') if e.fp else 'No error details'
            print(f"Error: API request failed with status {e.code}: {error_body}", file=sys.stderr)
            sys.exit(1)
        except urllib.error.URLError as e:
            print(f"Error: Network error: {e.reason}", file=sys.stderr)
            sys.exit(1)
        except Exception as e:
            print(f"Error: {e}", file=sys.stderr)
            sys.exit(1)


def setup_config(args):
    """Setup configuration interactively or from arguments"""
    config = Config(args.config)

    if args.api_key:
        config.set('api_key', args.api_key)
    if args.base_uri:
        config.set('base_uri', args.base_uri)
    if args.model:
        config.set('model', args.model)

    # Interactive setup if no arguments provided
    if not any([args.api_key, args.base_uri, args.model]):
        print("=== Bash Copilot Configuration ===\n")

        current_key = config.get('api_key', '')
        masked_key = f"{current_key[:8]}..." if current_key else "not set"
        api_key = input(f"OpenAI API Key (current: {masked_key}): ").strip()
        if api_key:
            config.set('api_key', api_key)

        current_uri = config.base_uri
        base_uri = input(f"Base URI (current: {current_uri}): ").strip()
        if base_uri:
            config.set('base_uri', base_uri)

        current_model = config.model
        model = input(f"Model name (current: {current_model}): ").strip()
        if model:
            config.set('model', model)

    config.save_config()


def complete_command(args):
    """Complete a bash command using OpenAI"""
    config = Config(args.config)

    if not config.api_key:
        print("Error: OpenAI API key not configured. Run 'bash-copilot config' to set it up.", file=sys.stderr)
        sys.exit(1)

    client = OpenAIClient(config.api_key, config.base_uri, config.model)

    # Get the partial command from stdin or argument
    if args.command:
        partial_command = args.command
    else:
        partial_command = sys.stdin.read().strip()

    if not partial_command:
        print("Error: No command provided", file=sys.stderr)
        sys.exit(1)

    completion = client.complete(partial_command, context=args.context)
    print(completion)


def install_completion_script(args):
    """Install bash completion script"""
    script_dir = Path(__file__).parent.absolute()
    completion_script = script_dir / "bash_copilot_completion.sh"

    if not completion_script.exists():
        print(f"Error: Completion script not found at {completion_script}", file=sys.stderr)
        sys.exit(1)

    bashrc = Path.home() / ".bashrc"
    source_line = f'\nsource "{completion_script}"\n'

    try:
        with open(bashrc, 'r') as f:
            content = f.read()

        if str(completion_script) in content:
            print(f"Completion script already installed in {bashrc}")
        else:
            with open(bashrc, 'a') as f:
                f.write(source_line)
            print(f"Completion script added to {bashrc}")
            print("Run 'source ~/.bashrc' or restart your shell to activate.")

    except IOError as e:
        print(f"Error: Failed to update {bashrc}: {e}", file=sys.stderr)
        sys.exit(1)


def main():
    parser = argparse.ArgumentParser(
        description='Bash Copilot - AI-powered bash command completion',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  bash-copilot config --api-key sk-xxx --model gpt-4
  bash-copilot complete "list all pdf files"
  echo "find large files" | bash-copilot complete
        """
    )

    parser.add_argument('--config', help='Path to config file', default=None)

    subparsers = parser.add_subparsers(dest='command', help='Commands')

    # Config command
    config_parser = subparsers.add_parser('config', help='Configure Bash Copilot')
    config_parser.add_argument('--api-key', help='OpenAI API key')
    config_parser.add_argument('--base-uri', help='OpenAI API base URI')
    config_parser.add_argument('--model', help='OpenAI model name')

    # Complete command
    complete_parser = subparsers.add_parser('complete', help='Complete a bash command')
    complete_parser.add_argument('command', nargs='?', help='Partial command to complete')
    complete_parser.add_argument('--context', action='store_true', help='Include context information')

    # Install command
    install_parser = subparsers.add_parser('install', help='Install bash completion script')

    args = parser.parse_args()

    if not args.command:
        parser.print_help()
        sys.exit(1)

    if args.command == 'config':
        setup_config(args)
    elif args.command == 'complete':
        complete_command(args)
    elif args.command == 'install':
        install_completion_script(args)


if __name__ == '__main__':
    main()
