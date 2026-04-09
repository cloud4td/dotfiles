#!/usr/bin/env bash
# Setup nvm (Node Version Manager) and install Node.js
# This script installs nvm if not present and configures Node.js

set -e

echo "🚀 Setting up nvm for Node.js version management..."

export NVM_DIR="$HOME/.nvm"

# Check if nvm is already installed
if [ -s "$NVM_DIR/nvm.sh" ]; then
    source "$NVM_DIR/nvm.sh"
    echo "✅ nvm is already installed ($(nvm --version))"
else
    echo "📦 Installing nvm via install script..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    source "$NVM_DIR/nvm.sh"
    echo "✅ nvm installed successfully!"
fi

echo ""
echo "📋 Checking Node.js version from .node-version / .nvmrc..."

# Determine Node.js version from .node-version or .nvmrc file
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ -f "$DOTFILES_DIR/.nvmrc" ]; then
    echo "📋 Node.js version from .nvmrc:"
    cat "$DOTFILES_DIR/.nvmrc"

    echo ""
    echo "📦 Installing Node.js via nvm..."
    cd "$DOTFILES_DIR"
    nvm install

    echo ""
    echo "✅ Node.js installed and configured"
elif [ -f "$DOTFILES_DIR/.node-version" ]; then
    echo "📋 Node.js version from .node-version:"
    cat "$DOTFILES_DIR/.node-version"

    echo ""
    echo "📦 Installing Node.js via nvm..."
    cd "$DOTFILES_DIR"
    nvm install "$(cat .node-version)"

    echo ""
    echo "✅ Node.js installed and configured"
else
    echo "⚠️  No .nvmrc or .node-version file found, installing LTS..."
    nvm install --lts
    nvm alias default lts/*
    echo "✅ Node.js LTS installed successfully!"
fi

# Display current Node.js version
echo ""
echo "📊 Current Node.js configuration:"
echo "   Node version: $(node --version)"
echo "   npm version:  $(npm --version)"
echo "   Location:     $(which node)"
echo ""

# Setup package managers (Yarn and pnpm)
echo "📦 Setting up package managers..."
echo ""

# Enable Corepack (built-in since Node.js 16.10)
if command -v corepack &> /dev/null; then
    echo "🔧 Enabling Corepack for Yarn and pnpm..."
    corepack enable

    # Install Yarn via Corepack
    if ! command -v yarn &> /dev/null; then
        echo "📦 Installing Yarn via Corepack..."
        corepack prepare yarn@stable --activate
        echo "✅ Yarn installed: $(yarn --version)"
    else
        echo "✅ Yarn is already available: $(yarn --version)"
    fi

    # Install pnpm via Corepack
    if ! command -v pnpm &> /dev/null; then
        echo "📦 Installing pnpm via Corepack..."
        corepack prepare pnpm@latest --activate
        echo "✅ pnpm installed: $(pnpm --version)"
    else
        echo "✅ pnpm is already available: $(pnpm --version)"
    fi
else
    echo "⚠️  Corepack not available (requires Node.js 16.10+)"

    # Fallback to npm global install
    if ! command -v yarn &> /dev/null; then
        read -p "Install Yarn globally via npm? (Y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            npm install -g yarn
            echo "✅ Yarn installed: $(yarn --version)"
        fi
    else
        echo "✅ Yarn is already available: $(yarn --version)"
    fi

    if ! command -v pnpm &> /dev/null; then
        read -p "Install pnpm globally via npm? (Y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            npm install -g pnpm
            echo "✅ pnpm installed: $(pnpm --version)"
        fi
    else
        echo "✅ pnpm is already available: $(pnpm --version)"
    fi
fi

echo ""

# Check if there are old Homebrew node installations
if brew list 2>/dev/null | grep -qE '^node(@[0-9]+)?$'; then
    echo "⚠️  Found Homebrew Node.js installations:"
    brew list | grep -E '^node'
    echo ""
    read -p "Remove Homebrew Node.js installations? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🗑️  Removing Homebrew Node.js..."
        brew uninstall node node@18 node@20 --ignore-dependencies 2>/dev/null || true
        echo "✅ Homebrew Node.js removed"
    fi
fi

# Check if fnm is still installed and offer to remove it
if command -v fnm &> /dev/null; then
    echo ""
    echo "⚠️  fnm is still installed."
    read -p "Remove fnm via Homebrew? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        brew uninstall fnm 2>/dev/null || true
        echo "✅ fnm removed"
    fi
fi

echo ""
echo "✅ nvm setup complete!"
echo ""
echo "📚 Quick Reference:"
echo ""
echo "   Node.js Version Management:"
echo "      nvm ls                   # List installed Node.js versions"
echo "      nvm install 20           # Install Node.js 20"
echo "      nvm install              # Install version from .nvmrc"
echo "      nvm use 20               # Switch to Node.js 20"
echo "      nvm alias default 24     # Set Node.js 24 as default"
echo "      nvm install --lts        # Install latest LTS"
echo ""
echo "   Package Managers:"
echo "      npm install <package>    # Install with npm"
echo "      yarn add <package>       # Install with Yarn"
echo "      pnpm add <package>       # Install with pnpm"
echo "      corepack enable          # Enable Yarn/pnpm via Corepack"
echo ""
echo "💡 Tip: Create .nvmrc file in your project to pin versions"
echo "   Example: echo \"20\" > .nvmrc"
