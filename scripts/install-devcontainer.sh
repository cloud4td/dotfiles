#!/usr/bin/env bash
# Dotfiles installation script for devcontainer (Ubuntu/Debian based)
# This script uses apt instead of Homebrew

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "🐧 Installing dotfiles for devcontainer from $DOTFILES_DIR..."

# Detect if running in Codespaces or local Dev Container
is_codespaces() {
    [ -n "$CODESPACES" ] || [ -n "$GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN" ]
}

# Replace Ubuntu sources with Aliyun mirror for local containers (China users)
if ! is_codespaces; then
    echo ""
    echo "🌏 Detected local Dev Container, switching to Aliyun mirror..."
    
    # Backup original sources.list
    if [ -f /etc/apt/sources.list ] && [ ! -f /etc/apt/sources.list.backup ]; then
        sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
        echo "📦 Backed up original sources.list"
    fi
    
    # Get Ubuntu version codename
    UBUNTU_CODENAME=$(lsb_release -cs)
    
    # Replace with Aliyun mirror
    sudo tee /etc/apt/sources.list > /dev/null <<EOF
# Aliyun Ubuntu Mirror
deb http://mirrors.aliyun.com/ubuntu/ ${UBUNTU_CODENAME} main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ ${UBUNTU_CODENAME}-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ ${UBUNTU_CODENAME}-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ ${UBUNTU_CODENAME}-security main restricted universe multiverse
EOF
    
    echo "✅ Switched to Aliyun mirror for faster downloads"
else
    echo ""
    echo "☁️  Detected GitHub Codespaces, using default mirrors"
fi

# Backup existing configuration
backup_if_exists() {
    if [ -f "$1" ] || [ -L "$1" ]; then
        echo "Backing up existing $1 to $1.backup"
        mv "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
    fi
}

# Create symbolic link
create_symlink() {
    local source="$1"
    local target="$2"

    backup_if_exists "$target"

    echo "Creating symlink: $target -> $source"
    ln -sf "$source" "$target"
}

# Install zsh configuration
echo ""
echo "📝 Setting up zsh configuration..."
create_symlink "$DOTFILES_DIR/zsh/.zshenv" "$HOME/.zshenv"
create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo ""
    echo "📦 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Create dotfiles symlink to HOME
if [ ! -L "$HOME/dotfiles" ] && [ "$DOTFILES_DIR" != "$HOME/dotfiles" ]; then
    echo ""
    echo "🔗 Creating symlink: ~/dotfiles -> $DOTFILES_DIR"
    ln -sf "$DOTFILES_DIR" "$HOME/dotfiles"
fi

# Install common CLI tools using apt
echo ""
echo "📦 Installing common CLI tools via apt..."
sudo apt-get update -qq

# Modern CLI tools
tools=(
    "bat"           # Better cat
    "exa"           # Better ls
    "fd-find"       # Better find
    "ripgrep"       # Better grep
    "fzf"           # Fuzzy finder
    "tree"          # Directory tree
    "htop"          # Better top
    "wget"          # Download tool
    "curl"          # Transfer tool
    "git"           # Version control
    "jq"            # JSON processor
    "vim"           # Text editor
    "tmux"          # Terminal multiplexer
)

for tool in "${tools[@]}"; do
    if dpkg -l | grep -q "^ii  $tool "; then
        echo "✅ $tool is already installed"
    else
        echo "📦 Installing $tool..."
        sudo apt-get install -y "$tool" > /dev/null 2>&1 || echo "⚠️  Failed to install $tool"
    fi
done

# Create aliases for tools with different names on Ubuntu
if ! command -v bat &> /dev/null && command -v batcat &> /dev/null; then
    echo "🔗 Creating alias: bat -> batcat"
    mkdir -p "$HOME/.local/bin"
    ln -sf /usr/bin/batcat "$HOME/.local/bin/bat"
fi

if ! command -v fd &> /dev/null && command -v fdfind &> /dev/null; then
    echo "🔗 Creating alias: fd -> fdfind"
    mkdir -p "$HOME/.local/bin"
    ln -sf /usr/bin/fdfind "$HOME/.local/bin/fd"
fi

# Setup secrets file
echo ""
echo "🔐 Setting up secrets file..."
if [ ! -f "$DOTFILES_DIR/zsh/secrets.zsh" ]; then
    cp "$DOTFILES_DIR/zsh/secrets.zsh.example" "$DOTFILES_DIR/zsh/secrets.zsh"
    echo "✅ Created secrets.zsh from example"
else
    echo "✅ secrets.zsh already exists"
fi

echo ""
echo "✅ Dotfiles installation for devcontainer complete!"
echo ""
echo "📌 Next steps:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Customize ~/dotfiles/zsh/env.zsh and ~/dotfiles/zsh/aliases.zsh as needed"
echo "3. Update ~/dotfiles/zsh/secrets.zsh with your tokens"
echo ""
echo "⚠️  IMPORTANT: secrets.zsh is in .gitignore and will NOT be committed to git"
