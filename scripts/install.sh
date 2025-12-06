#!/usr/bin/env bash
# Dotfiles installation script
# For installing configuration on new machines or devcontainer

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Installing dotfiles from $DOTFILES_DIR..."

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
echo "Setting up zsh configuration..."
create_symlink "$DOTFILES_DIR/zsh/.zshenv" "$HOME/.zshenv"
create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

# Check if Oh My Zsh needs to be installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo ""
    read -p "Oh My Zsh not found. Install it? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
fi

# Create dotfiles symlink to HOME
if [ ! -L "$HOME/dotfiles" ] && [ "$DOTFILES_DIR" != "$HOME/dotfiles" ]; then
    echo ""
    echo "Creating symlink: ~/dotfiles -> $DOTFILES_DIR"
    ln -sf "$DOTFILES_DIR" "$HOME/dotfiles"
fi

echo ""
echo "✓ Dotfiles installation complete!"
echo ""
echo "Next steps:"
echo "1. secrets.zsh has been created with your current tokens"
echo "2. Restart your terminal or run: source ~/.zshrc"
echo "3. Customize ~/dotfiles/zsh/env.zsh and ~/dotfiles/zsh/aliases.zsh as needed"
echo ""
echo "⚠️  IMPORTANT: secrets.zsh is in .gitignore and will NOT be committed to git"
