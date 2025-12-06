# Public Environment Variables
# These configurations can be safely committed to git
# Loaded by .zshenv, applies to all shells (interactive and non-interactive)

# Dotfiles bin directory (custom commands)
export PATH="$HOME/dotfiles/bin:$PATH"

# Java
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Docker
export PATH="$PATH:$HOME/.docker/bin"
export PATH="/usr/local/sbin:$PATH"

# Homebrew
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles
