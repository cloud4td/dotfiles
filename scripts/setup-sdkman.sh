#!/usr/bin/env bash
# Setup SDKMAN and install Java
# This script installs SDKMAN if not present and configures Java

set -e

echo "🚀 Setting up SDKMAN for Java version management..."

# Check if SDKMAN is already installed
if [ -d "$HOME/.sdkman" ]; then
    echo "✅ SDKMAN is already installed at $HOME/.sdkman"
else
    echo "📦 Installing SDKMAN..."
    curl -s "https://get.sdkman.io" | bash
    
    if [ $? -eq 0 ]; then
        echo "✅ SDKMAN installed successfully!"
    else
        echo "❌ Failed to install SDKMAN"
        exit 1
    fi
fi

# Source SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Check if SDKMAN is now available
if ! command -v sdk &> /dev/null; then
    echo "⚠️  SDKMAN installed but not available in current shell"
    echo "Please restart your terminal or run: source ~/.zshrc"
    exit 0
fi

# Enable auto-env for automatic SDK switching based on .sdkmanrc
echo ""
echo "🔧 Configuring SDKMAN auto-env..."
sdk config sdkman_auto_env true
echo "✅ Auto-env enabled - SDKs will auto-switch when entering directories with .sdkmanrc"

echo ""
echo "📋 Checking SDKs from .sdkmanrc..."

# Determine SDKs from .sdkmanrc file
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ -f "$DOTFILES_DIR/.sdkmanrc" ]; then
    # Display SDKs to be installed
    echo "📋 SDKs from .sdkmanrc:"
    grep "^[a-z].*=" "$DOTFILES_DIR/.sdkmanrc" | while read -r line; do
        [ -n "$line" ] && echo "   - $line"
    done
    
    # Install SDKs via SDKMAN using sdk env install
    echo ""
    echo "📦 Installing SDKs via SDKMAN..."
    cd "$DOTFILES_DIR"
    sdk env install
    
    echo ""
    echo "✅ All SDKs installed and configured"
else
    echo "⚠️  No .sdkmanrc file found, skipping SDK installation"
    echo "💡 Create .sdkmanrc file with: sdk env init"
    exit 0
fi

echo ""
echo "✅ SDKMAN setup complete!"
echo ""
echo "📊 Current SDK configuration:"
echo "Java:   $(java -version 2>&1 | head -n 1)"
echo "Maven:  $(mvn -version 2>&1 | head -n 1)"
echo "Gradle: $(gradle -version 2>&1 | grep "Gradle" | head -n 1)"
echo "Kotlin: $(kotlin -version 2>&1)"
echo "Scala:  $(scala -version 2>&1)"
echo ""
echo "📚 Quick Reference:"
echo ""
echo "   SDK Version Management:"
echo "      sdk list java              # List available versions"
echo "      sdk install java 21-tem    # Install Java 21"
echo "      sdk env install            # Install all SDKs from .sdkmanrc"
echo "      sdk current                # Show all current versions"
echo ""

