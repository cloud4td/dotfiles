# Zsh Environment Variables
# 这个文件在每次启动 zsh 时都会加载（包括非交互式 shell）
# 适合放环境变量、PATH 等

# Load custom configurations
DOTFILES_DIR="$HOME/dotfiles"

# Load public environment variables
[ -f "$DOTFILES_DIR/zsh/env.zsh" ] && source "$DOTFILES_DIR/zsh/env.zsh"

# Load local secrets (not in git)
[ -f "$DOTFILES_DIR/zsh/secrets.zsh" ] && source "$DOTFILES_DIR/zsh/secrets.zsh"
