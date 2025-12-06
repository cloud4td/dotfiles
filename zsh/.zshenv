# Zsh Environment Variables
# This file is loaded every time zsh starts (including non-interactive shells)
# Suitable for environment variables, PATH, etc.

# Load custom configurations
DOTFILES_DIR="$HOME/dotfiles"

# Load public environment variables
[ -f "$DOTFILES_DIR/zsh/env.zsh" ] && source "$DOTFILES_DIR/zsh/env.zsh"

# Load local secrets (not in git)
[ -f "$DOTFILES_DIR/zsh/secrets.zsh" ] && source "$DOTFILES_DIR/zsh/secrets.zsh"
