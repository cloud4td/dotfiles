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

echo ""
echo "📋 Checking current Java installation..."

# Check if Java 17 (Temurin) is already installed via SDKMAN
JAVA_VERSION="17.0.17-tem"
INSTALLED_JAVA=$(sdk list java | grep "installed" | grep "$JAVA_VERSION" || true)

if [ -n "$INSTALLED_JAVA" ]; then
    echo "✅ Java $JAVA_VERSION is already installed"
else
    echo "📦 Installing Java $JAVA_VERSION..."
    sdk install java "$JAVA_VERSION"
    
    if [ $? -eq 0 ]; then
        echo "✅ Java $JAVA_VERSION installed successfully!"
    else
        echo "❌ Failed to install Java $JAVA_VERSION"
        echo "💡 Tip: Run 'sdk list java' to see available versions"
        exit 1
    fi
fi

# Set as default
echo ""
echo "🔧 Setting Java $JAVA_VERSION as default..."
sdk default java "$JAVA_VERSION"

echo ""
echo "✅ SDKMAN setup complete!"
echo ""
echo "📊 Current Java version:"
java -version
echo ""
echo "📍 JAVA_HOME: $JAVA_HOME"
echo ""
echo "💡 Useful SDKMAN commands:"
echo "  sdk list java              - List available Java versions"
echo "  sdk install java <version> - Install a specific version"
echo "  sdk use java <version>     - Use version for current shell"
echo "  sdk default java <version> - Set as global default"
echo "  sdk current java           - Show current version"
echo "  sdk upgrade java           - Upgrade to latest version"
