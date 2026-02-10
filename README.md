# Dotfiles

Personal configuration file management repository for macOS, devcontainer, and GitHub Codespaces.

## 📁 Directory Structure

```
dotfiles/
├── .devcontainer/          # VS Code devcontainer configuration
│   └── devcontainer.json
├── bin/                    # Custom executable commands
│   ├── auto-approve-pr    # Example: Auto-approve PR
├── vscode/                # VS Code configuration
│   ├── settings.json      # Editor settings
│   ├── keybindings.json   # Custom keybindings
│   ├── extensions.txt     # Extension list
│   ├── mcp.json.example   # MCP server configuration template
│   └── snippets.code-snippets # Global code snippets
├── zsh/                    # Zsh configuration
│   ├── .zshenv            # Environment variables (loaded by all shells)
│   ├── .zshrc             # Interactive shell config (Oh My Zsh, aliases, etc.)
│   ├── env.zsh            # Public environment variables (committed to git)
│   ├── aliases.zsh        # Alias definitions (committed to git)
│   ├── functions.zsh      # Custom commands and functions (committed to git)
│   ├── prompt.zsh         # Custom prompt configuration (committed to git)
│   ├── warp.zsh           # Warp terminal specific config (committed to git)
│   ├── secrets.zsh        # Sensitive information (not committed, in .gitignore)
│   └── secrets.zsh.example # Sensitive information template
├── scripts/               # Installation and configuration scripts
│   ├── install.sh         # Main installation script
│   ├── setup-vscode.sh    # VS Code configuration setup
│   ├── setup-mcp.sh       # MCP configuration setup
│   ├── setup-tools.sh     # Common CLI tools installation
│   ├── setup-fnm.sh       # Node.js version manager setup
│   ├── setup-python.sh    # Python environment setup (uv + Poetry)
│   ├── setup-sdkman.sh    # Java/JVM tools manager setup
│   ├── setup-dotnet.sh    # .NET SDK setup
│   ├── setup-podman.sh    # Podman (Docker replacement) setup
│   └── setup-zsh-plugins.sh # Zsh plugins installation
├── .gitignore
└── README.md
```

## 📚 Configuration Files Description

- **`.zshenv`** - Loaded every time zsh starts (including non-interactive shells)
  - Suitable for: environment variables, PATH, credentials, etc.
  - Load order: loaded first

- **`.zshrc`** - Loaded only for interactive shells
  - Suitable for: Oh My Zsh, aliases, prompts, plugins
  - Load order: after .zshenv

- **`env.zsh`** - Public environment variables
  - Java, Python, Docker path configurations, etc.

- **`aliases.zsh`** - Command aliases
- **`functions.zsh`** - Custom commands and functions
  - Complex custom commands, shell functions
  - Can include logic and parameter handling

- **`bin/`** - Standalone executable command scripts
  - Independent command-line tools (e.g., `auto-approve-pr`)
  - Added to PATH, can be executed directly in terminal
  - Each command is a separate file, easy to manage and version control

## 🔐 Security Design

### Sensitive Information Management Strategy

This repository uses **separation management**, dividing configurations into two categories:

**✅ Public Configuration** (committed to git)

- `zsh/env.zsh` - General environment variables (Java, Python, Node.js, Podman paths, etc.)
- `zsh/aliases.zsh` - Command aliases (including Podman Docker compatibility aliases)
- `zsh/.zshrc` - Main configuration file

**🔒 Sensitive Configuration** (not committed to git)

- `zsh/secrets.zsh` - Contains all tokens, credentials
- Excluded in `.gitignore`, will never be committed

### Three Ways to Manage Tokens

#### Option 1: Local Development (Recommended) ✨

```bash
# secrets.zsh already contains your current tokens
# It's in .gitignore and won't be committed to git

# Verify git status
cd ~/work/talkdesk/code/dotfiles
git status  # should not see secrets.zsh
```

#### Option 2: New Machine Migration

```bash
# On new machine
git clone https://github.com/cloud4td/dotfiles.git ~/work/talkdesk/code/dotfiles
cd ~/work/talkdesk/code/dotfiles

# Manually create secrets.zsh (from template or manual input)
cp zsh/secrets.zsh.example zsh/secrets.zsh
vim zsh/secrets.zsh  # Fill in real tokens

# Run installation
./scripts/install.sh
```

#### Option 3: Using in devcontainer or GitHub Codespaces 🐳

In VS Code devcontainer or GitHub Codespaces, sensitive information is passed via **environment variables**:

**Option A - Local Environment Variables** (For devcontainer)

```bash
# Your tokens are already in ~/.zshrc on your host machine
# devcontainer will automatically read these environment variables from host
# No additional action needed!
```

**Option B - GitHub Codespaces Secrets** (For Codespaces)

1. Go to GitHub repository → Settings
2. Secrets and variables → Codespaces
3. Add required secrets:
   - `COPILOT_MCP_FIGMA_API_TOKEN`
   - `SNYK_TOKEN`
   - etc...
4. These secrets will be automatically available as environment variables in your Codespace

## 🚀 Quick Start

### Apply Configuration on Current Machine

```bash
# 1. Backup current configuration (automatically done)
# 2. Run installation script
cd ~/work/talkdesk/code/dotfiles
chmod +x scripts/install.sh
./scripts/install.sh

# 3. Reload configuration
source ~/.zshrc

# 4. Verify
echo $SNYK_TOKEN  # should output your token
```

### Commit to Git

```bash
cd ~/work/talkdesk/code/dotfiles

# Check files to be committed
git status

# Confirm secrets.zsh is not in the list!
git add .
git commit -m "Add dotfiles configuration"
git push
```

## 📝 Update Configuration

```bash
# Modify public configuration
vim ~/dotfiles/zsh/env.zsh

# Commit to git
cd ~/dotfiles
git add zsh/env.zsh
git commit -m "Update environment config"
git push

# Pull updates on other machines
git pull
source ~/.zshrc
```

## ⚠️ Security Reminder

- ✅ `secrets.zsh` is created and contains your real tokens
- ✅ `secrets.zsh` is in `.gitignore` and won't be committed
- ⚠️ Use `git status` to confirm no accidental commits of sensitive files
- 🔄 Regularly rotate your tokens
- 🚨 If accidentally committed, use `git filter-branch` or BFG Repo-Cleaner to clean history

## 🛠️ Dependencies

### Core Tools

- zsh
- oh-my-zsh (automatically installed by installation script)
- git
- Homebrew (macOS package manager)

### Development Tools (installed via setup scripts)

- **Node.js**: fnm (Fast Node Manager)
- **Python**: uv + Poetry
- **Java/JVM**: SDKMAN (manages Java, Maven, Gradle, Kotlin, Scala)
- **.NET**: .NET SDK (supports multiple versions via global.json)
- **Containers**: Podman (Docker replacement with compatibility mode)
  - docker-compose
  - podman-compose

### Setup Scripts

```bash
# Run individual setup scripts
./scripts/setup-fnm.sh      # Install Node.js via fnm
./scripts/setup-python.sh   # Install Python via uv
./scripts/setup-sdkman.sh   # Install Java/JVM via SDKMAN
./scripts/setup-dotnet.sh   # Install .NET SDK
./scripts/setup-podman.sh   # Install Podman with Docker compatibility
```

## 💡 Terminal Support

This configuration supports the following terminals:

- **Warp** - Modern terminal, automatically reads `.zshrc` and all configurations
- **VS Code Integrated Terminal** - Configured via `EDITOR=code`
- **iTerm2** - Standard zsh configuration
- **Default macOS Terminal** - Standard zsh configuration

Warp specific notes:

- Warp automatically applies your Oh My Zsh themes and plugins
- Warp's AI features and auto-completion remain enabled
- All environment variables and aliases work normally
- `warp.zsh` file can be used to add Warp-specific configurations

## 📄 License

MIT
