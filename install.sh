#!/bin/bash
# Dotfiles installation script

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${GREEN}Installing dotfiles from ${DOTFILES_DIR}${NC}"

# Backup existing dotfiles
backup_file() {
    if [ -f "$1" ] || [ -L "$1" ]; then
        echo -e "${YELLOW}Backing up existing $1 to $1.backup${NC}"
        mv "$1" "$1.backup"
    fi
}

# Create symlink
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [ -e "$target" ] || [ -L "$target" ]; then
        backup_file "$target"
    fi
    
    echo -e "${GREEN}Creating symlink: $target -> $source${NC}"
    ln -sf "$source" "$target"
}

# Install dotfiles
echo ""
echo "Installing configuration files..."
echo ""

create_symlink "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
create_symlink "$DOTFILES_DIR/.bash_profile" "$HOME/.bash_profile"
create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES_DIR/.gitignore_global" "$HOME/.gitignore_global"
create_symlink "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"

echo ""
echo -e "${GREEN}✓ Dotfiles installation complete!${NC}"
echo ""
echo "Note: You may need to:"
echo "  1. Update .gitconfig with your name and email"
echo "  2. Restart your terminal or run 'source ~/.bashrc'"
echo ""