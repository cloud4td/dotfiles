# Public Environment Variables
# These configurations can be safely committed to git
# Loaded by .zshenv, applies to all shells (interactive and non-interactive)

# Dotfiles bin directory (custom commands)
export PATH="$HOME/dotfiles/bin:$PATH"

# Java
export JAVA_HOME=/Users/cloud/Library/Java/JavaVirtualMachines/temurin-17.0.15/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH

# Docker
export PATH="$PATH:$HOME/.docker/bin"
export PATH="/usr/local/sbin:$PATH"

# Python
export PYTHONPATH=.venv/lib/python3.11/site-packages
export DYLD_LIBRARY_PATH=.venv/lib/python3.11/site-packages/jep

# Homebrew
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles
