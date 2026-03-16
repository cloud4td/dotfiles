#!/usr/bin/env bash
# Setup common CLI development tools
# This script installs useful command-line tools for development

set -e

echo "🚀 Setting up common CLI development tools..."

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew is not installed. Please run ./setup-homebrew.sh first"
    exit 1
fi

echo "✅ Homebrew is available"
echo ""

# Function to install tool if not present
install_tool() {
    local tool=$1
    local package=${2:-$tool}
    
    if command -v "$tool" &> /dev/null; then
        echo "✅ $tool is already installed ($(command -v $tool))"
    else
        echo "📦 Installing $package..."
        brew install "$package"
        echo "✅ $tool installed"
    fi
}

# Modern replacements for classic Unix tools
echo "📦 Installing modern CLI tools..."
echo ""

install_tool "bat" "bat"           # Better cat with syntax highlighting
install_tool "eza" "eza"           # Better ls with colors and git integration (successor to exa)
install_tool "fd" "fd"             # Better find
install_tool "rg" "ripgrep"        # Better grep (ripgrep)
install_tool "fzf" "fzf"           # Fuzzy finder
install_tool "tldr" "tldr"         # Simplified man pages
install_tool "htop" "htop"         # Better top
install_tool "tree" "tree"         # Directory tree viewer
install_tool "wget" "wget"         # Download tool
install_tool "curl" "curl"         # Transfer tool

echo ""
echo "📦 Installing developer tools..."
echo ""

install_tool "jq" "jq"             # JSON processor
install_tool "yq" "yq"             # YAML processor
install_tool "gh" "gh"             # GitHub CLI
install_tool "glab" "glab"         # GitLab CLI
install_tool "httpie" "httpie"     # User-friendly HTTP client
install_tool "hey" "hey"           # HTTP load generator
install_tool "dive" "dive"         # Docker image analyzer

echo ""
echo "📦 Installing productivity tools..."
echo ""

install_tool "zoxide" "zoxide"     # Smarter cd command
install_tool "tmux" "tmux"         # Terminal multiplexer
install_tool "ncdu" "ncdu"         # Disk usage analyzer
install_tool "lazygit" "lazygit"   # Terminal UI for git
install_tool "lazydocker" "lazydocker" # Terminal UI for docker/podman

# Configure fzf key bindings
if command -v fzf &> /dev/null; then
    echo ""
    echo "🔧 Configuring fzf key bindings..."
    
    if [ -f ~/.fzf.zsh ]; then
        echo "✅ fzf already configured"
    else
        $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc
        echo "✅ fzf configured (Ctrl+R for history, Ctrl+T for files)"
    fi
fi

# Configure zoxide
if command -v zoxide &> /dev/null; then
    echo ""
    echo "💡 To enable zoxide, add to your .zshrc:"
    echo '   eval "$(zoxide init zsh)"'
    echo "   Then use 'z <directory>' instead of 'cd'"
fi

echo ""
echo "✅ CLI tools installation complete!"
echo ""
echo "📚 Quick Reference:"
echo ""
echo "   Modern Unix Tools:"
echo "      bat <file>              # Syntax-highlighted cat"
echo "      eza -la                 # Modern ls with git status"
echo "      fd <pattern>            # Fast file search"
echo "      rg <pattern>            # Fast text search"
echo "      fzf                     # Fuzzy finder (Ctrl+R, Ctrl+T)"
echo "      z <dir>                 # Smart cd (if configured)"
echo ""
echo "   Developer Tools:"
echo "      jq '.key' file.json     # Parse JSON"
echo "      yq '.key' file.yaml     # Parse YAML"
echo "      gh repo list            # GitHub CLI"
echo "      http GET url            # HTTPie request"
echo "      lazygit                 # Git TUI"
echo "      lazydocker              # Docker/Podman TUI"
echo ""
echo "   Productivity:"
echo "      tldr <command>          # Quick command examples"
echo "      htop                    # Process monitor"
echo "      ncdu                    # Disk usage"
echo "      tree -L 2               # Directory tree (2 levels)"
echo ""
echo "💡 Tips:"
echo "   - Use 'bat' instead of 'cat' for syntax highlighting"
echo "   - Use 'eza -la' instead of 'ls -la' for better output"
echo "   - Use 'rg' instead of 'grep' for faster searching"
echo "   - Press Ctrl+R to search command history with fzf"
echo ""
