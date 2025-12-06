#!/usr/bin/env bash
# Setup fnm (Fast Node Manager) and install Node.js
# This script installs fnm if not present and configures Node.js

set -e

echo "🚀 Setting up fnm for Node.js version management..."

# Check if fnm is already installed
if command -v fnm &> /dev/null; then
    echo "✅ fnm is already installed ($(fnm --version))"
else
    echo "📦 Installing fnm via Homebrew..."
    if command -v brew &> /dev/null; then
        brew install fnm
        echo "✅ fnm installed successfully!"
    else
        echo "❌ Homebrew not found. Please install Homebrew first:"
        echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
fi

# Initialize fnm for current shell
eval "$(fnm env --use-on-cd)"

echo ""
echo "📋 Checking Node.js version from .node-version..."

# Determine Node.js version from .node-version file
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ -f "$DOTFILES_DIR/.node-version" ]; then
    echo "📋 Node.js version from .node-version:"
    cat "$DOTFILES_DIR/.node-version"
    
    # Install Node.js version via fnm (automatically reads .node-version)
    echo ""
    echo "📦 Installing Node.js via fnm..."
    cd "$DOTFILES_DIR"
    fnm install
    
    echo ""
    echo "✅ Node.js installed and configured"
else
    echo "⚠️  No .node-version file found, installing LTS..."
    fnm install --lts
    fnm use lts-latest
    fnm default lts-latest
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

echo ""
echo "✅ fnm setup complete!"
echo ""
echo "📚 Quick Reference:"
echo ""
echo "   Node.js Version Management:"
echo "      fnm list                 # List installed Node.js versions"
echo "      fnm install 20           # Install Node.js 20"
echo "      fnm install              # Install version from .node-version"
echo "      fnm use 20               # Switch to Node.js 20"
echo "      fnm default 24           # Set Node.js 24 as default"
echo "      fnm install --lts        # Install latest LTS"
echo ""
echo "   Package Managers:"
echo "      npm install <package>    # Install with npm"
echo "      yarn add <package>       # Install with Yarn"
echo "      pnpm add <package>       # Install with pnpm"
echo "      corepack enable          # Enable Yarn/pnpm via Corepack"
echo ""
echo "💡 Tip: Create .node-version file in your project to auto-switch versions"
echo "   Example: echo \"20\" > .node-version"
echo ""
