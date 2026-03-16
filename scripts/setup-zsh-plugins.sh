#!/usr/bin/env bash
# Setup zinit plugin manager and zsh plugins
# This script installs zinit, Powerlevel10k, and essential zsh plugins

set -e

echo "🔌 Setting up zinit and zsh plugins..."
echo ""

# ------------------------------------------
# Install zinit plugin manager
# ------------------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ -f "$ZINIT_HOME/zinit.zsh" ]; then
    echo "✅ zinit is already installed"
else
    echo "📦 Installing zinit..."
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    if [ $? -eq 0 ]; then
        echo "✅ zinit installed successfully!"
    else
        echo "❌ Failed to install zinit"
        exit 1
    fi
fi

echo ""

# ------------------------------------------
# Pre-clone plugins for faster first shell startup
# ------------------------------------------
# zinit auto-installs plugins on first `source ~/.zshrc`, but pre-cloning
# avoids the delay on first launch.

source "$ZINIT_HOME/zinit.zsh"

echo "📦 Pre-installing plugins via zinit..."
echo ""

# Powerlevel10k theme
echo "  → romkatv/powerlevel10k"
zinit ice depth=1
zinit light romkatv/powerlevel10k 2>/dev/null || true

# Essential plugins
for plugin in \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-completions \
    zsh-users/zsh-syntax-highlighting \
    zsh-users/zsh-history-substring-search; do
    echo "  → $plugin"
    zinit light "$plugin" 2>/dev/null || true
done

# OMZ snippets
for snippet in \
    OMZP::git \
    OMZP::docker \
    OMZP::docker-compose \
    OMZP::kubectl \
    OMZP::colored-man-pages \
    OMZP::command-not-found \
    OMZP::extract \
    OMZP::sudo \
    OMZP::web-search \
    OMZP::copypath \
    OMZP::copyfile \
    OMZP::dirhistory; do
    echo "  → $snippet"
    zinit snippet "$snippet" 2>/dev/null || true
done

echo ""
echo "🎉 Plugin installation complete!"
echo ""
echo "💡 Next steps:"
echo "  1. Reload your shell: source ~/.zshrc"
echo "  2. Or restart your terminal"
echo "  3. Run 'p10k configure' to set up Powerlevel10k theme"
echo ""
echo "📝 Installed components:"
echo "  • zinit                        - Plugin manager"
echo "  • Powerlevel10k                - Theme (async, zero-latency)"
echo "  • zsh-autosuggestions          - Fish-like autosuggestions"
echo "  • zsh-completions              - Enhanced Tab completions"
echo "  • zsh-syntax-highlighting      - Real-time syntax coloring"
echo "  • zsh-history-substring-search - ↑↓ history search by substring"
echo "  • OMZ snippets                 - git, docker, kubectl, etc."
echo ""
