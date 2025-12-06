# Public Environment Variables
# 这些配置可以安全地提交到 git

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
