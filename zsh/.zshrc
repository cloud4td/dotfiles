# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# Plugins
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Load custom configurations
DOTFILES_DIR="$HOME/dotfiles"

# Load public environment variables
[ -f "$DOTFILES_DIR/zsh/env.zsh" ] && source "$DOTFILES_DIR/zsh/env.zsh"

# Load aliases
[ -f "$DOTFILES_DIR/zsh/aliases.zsh" ] && source "$DOTFILES_DIR/zsh/aliases.zsh"

# Load Warp specific settings
[ -f "$DOTFILES_DIR/zsh/warp.zsh" ] && source "$DOTFILES_DIR/zsh/warp.zsh"

# Load local secrets (not in git)
[ -f "$DOTFILES_DIR/zsh/secrets.zsh" ] && source "$DOTFILES_DIR/zsh/secrets.zsh"

# Editor
export EDITOR=code

# GPG
export GPG_TTY=$(tty)
