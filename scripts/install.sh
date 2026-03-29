#!/usr/bin/env bash
# Dotfiles installation script
# For installing configuration on new machines or devcontainer
#
# Usage:
#   ./install.sh              — full install
#   ./install.sh --only memory — link Copilot memory directory only

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

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

# Link the entire Copilot memory directory to dotfiles/agents/memories/
setup_memory() {
    echo ""
    echo "Setting up Copilot memory directory symlink..."
    local parent="$HOME/Library/Application Support/Code/User/globalStorage/github.copilot-chat/memory-tool"
    local target="$parent/memories"
    mkdir -p "$parent"
    if [ -d "$target" ] && [ ! -L "$target" ]; then
        echo "  Backing up existing memories directory..."
        mv "$target" "${target}.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    if [ ! -L "$target" ]; then
        ln -sf "$DOTFILES_DIR/agents/copilot/memories" "$target"
        echo "  Linked: $target -> $DOTFILES_DIR/agents/copilot/memories"
    else
        echo "  Already linked: $target"
    fi
}

# Symlink Claude Code settings.json to dotfiles/agents/claude-settings.json
setup_claude_code() {
    echo ""
    echo "Setting up Claude Code settings symlink..."
    local claude_dir="$HOME/.claude"
    local target="$claude_dir/settings.json"
    local source="$DOTFILES_DIR/agents/claude/settings.json"
    mkdir -p "$claude_dir"
    if [ -f "$source" ]; then
        if [ -f "$target" ] && [ ! -L "$target" ]; then
            echo "  Backing up existing settings.json..."
            mv "$target" "${target}.backup.$(date +%Y%m%d_%H%M%S)"
        fi
        if [ ! -L "$target" ]; then
            ln -sf "$source" "$target"
            echo "  Linked: $target -> $source"
        else
            echo "  Already linked: $target"
        fi
    else
        echo "  ⚠️  agents/claude/settings.json not found in dotfiles, skipping"
    fi
}

# Parse --only flag
ONLY=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --only) ONLY="$2"; shift 2 ;;
        *) shift ;;
    esac
done

if [ "$ONLY" = "memory" ]; then
    setup_memory
    echo ""
    echo "✓ Memory symlink done."
    exit 0
fi

echo "Installing dotfiles from $DOTFILES_DIR..."

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

# Symlink Copilot memory directory
setup_memory

# Symlink Claude Code settings
setup_claude_code

echo ""
echo "✓ Dotfiles installation complete!"
echo ""
echo "Next steps:"
echo "1. secrets.zsh has been created with your current tokens"
echo "2. Restart your terminal or run: source ~/.zshrc"
echo "3. Customize ~/dotfiles/zsh/env.zsh and ~/dotfiles/zsh/aliases.zsh as needed"
echo ""
echo "⚠️  IMPORTANT: secrets.zsh is in .gitignore and will NOT be committed to git"
