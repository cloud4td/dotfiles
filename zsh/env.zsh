# Public Environment Variables
# These configurations can be safely committed to git
# Loaded by .zshenv, applies to all shells (interactive and non-interactive)

# Dotfiles bin directory (custom commands)
export PATH="$HOME/dotfiles/bin:$PATH"

# Java
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Node.js (fnm - Fast Node Manager)
eval "$(fnm env --use-on-cd)"

# Python
# uv manages Python versions (installed: 3.12, 3.13)
export PATH="$HOME/.local/bin:$PATH"

# Poetry - Python dependency management (installed via Homebrew)
# uv - Fast Python package and project manager (installed via Homebrew)
# Both Poetry and uv can coexist - use Poetry for existing projects, uv for new ones

# Podman (Docker replacement with compatibility mode)
# Docker socket is provided by Podman machine
export DOCKER_HOST="unix:///var/run/docker.sock"

# Legacy Docker paths (kept for compatibility)
export PATH="$PATH:$HOME/.docker/bin"
export PATH="/usr/local/sbin:$PATH"

# Homebrew
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles
