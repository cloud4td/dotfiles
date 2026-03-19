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
create_symlink "$DOTFILES_DIR/zsh/p10k.zsh" "$HOME/.p10k.zsh"

# Check if zinit needs to be installed
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -f "$ZINIT_HOME/zinit.zsh" ]; then
    echo ""
    read -p "zinit not found. Install it? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        mkdir -p "$(dirname "$ZINIT_HOME")"
        git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    fi
fi

# Create dotfiles symlink to HOME
if [ ! -L "$HOME/dotfiles" ] && [ "$DOTFILES_DIR" != "$HOME/dotfiles" ]; then
    echo ""
    echo "Creating symlink: ~/dotfiles -> $DOTFILES_DIR"
    ln -sf "$DOTFILES_DIR" "$HOME/dotfiles"
fi

# Link Copilot memory files from dotfiles into VS Code's memory-tool directory
echo ""
echo "Setting up Copilot memory symlinks..."
COPILOT_MEMORY_DIR="$HOME/Library/Application Support/Code/User/globalStorage/github.copilot-chat/memory-tool/memories"
if [ -d "$COPILOT_MEMORY_DIR" ] || mkdir -p "$COPILOT_MEMORY_DIR"; then
    for mem_file in "$DOTFILES_DIR/memories/"*.md; do
        [ -f "$mem_file" ] || continue
        fname="$(basename "$mem_file")"
        target="$COPILOT_MEMORY_DIR/$fname"
        if [ ! -L "$target" ]; then
            backup_if_exists "$target"
            ln -sf "$mem_file" "$target"
            echo "  Linked memory: $fname"
        fi
    done
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
