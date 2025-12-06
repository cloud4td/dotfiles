#!/usr/bin/env bash
# Setup Oh My Zsh plugins
# This script installs commonly used Oh My Zsh plugins

set -e

echo "🔌 Setting up Oh My Zsh plugins..."
echo ""

# Check if Oh My Zsh is installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "❌ Oh My Zsh is not installed"
    echo "💡 Run the install script first: ./scripts/install.sh"
    exit 1
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Install zsh-autosuggestions
if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "✅ zsh-autosuggestions is already installed"
else
    echo "📦 Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    if [ $? -eq 0 ]; then
        echo "✅ zsh-autosuggestions installed successfully!"
    else
        echo "❌ Failed to install zsh-autosuggestions"
    fi
fi

echo ""

# Install zsh-syntax-highlighting
if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "✅ zsh-syntax-highlighting is already installed"
else
    echo "📦 Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    if [ $? -eq 0 ]; then
        echo "✅ zsh-syntax-highlighting installed successfully!"
    else
        echo "❌ Failed to install zsh-syntax-highlighting"
    fi
fi

echo ""
echo "🎉 Plugin installation complete!"
echo ""
echo "💡 Next steps:"
echo "  1. Reload your shell: source ~/.zshrc"
echo "  2. Or restart your terminal"
echo ""
echo "📝 Installed plugins:"
echo "  • zsh-autosuggestions   - Fish-like autosuggestions"
echo "  • zsh-syntax-highlighting - Syntax highlighting for commands"
