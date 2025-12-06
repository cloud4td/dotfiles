# Oh My Zsh configuration
# 这个文件只在交互式 shell 时加载
# 适合放 Oh My Zsh、别名、提示符、插件等

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# Plugins
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Load custom configurations
DOTFILES_DIR="$HOME/dotfiles"

# Load aliases
[ -f "$DOTFILES_DIR/zsh/aliases.zsh" ] && source "$DOTFILES_DIR/zsh/aliases.zsh"

# Load custom functions and commands
[ -f "$DOTFILES_DIR/zsh/functions.zsh" ] && source "$DOTFILES_DIR/zsh/functions.zsh"

# Load Warp specific settings
[ -f "$DOTFILES_DIR/zsh/warp.zsh" ] && source "$DOTFILES_DIR/zsh/warp.zsh"

# td-cli Editor
export EDITOR=code

# GPG (交互式 shell 特定)
export GPG_TTY=$(tty)
