#!/usr/bin/env bash
# Setup .NET SDK with version management (similar to fnm, uv, sdkman)
# This script installs dotnet-install script for managing multiple .NET versions

set -e

echo "🚀 Setting up .NET SDK with version management..."

# Check if dotnet-install script exists
DOTNET_INSTALL_DIR="$HOME/.dotnet"
DOTNET_INSTALL_SCRIPT="$DOTNET_INSTALL_DIR/dotnet-install.sh"

if [ ! -f "$DOTNET_INSTALL_SCRIPT" ]; then
    echo "📦 Downloading dotnet-install script..."
    mkdir -p "$DOTNET_INSTALL_DIR"
    curl -sSL https://dot.net/v1/dotnet-install.sh -o "$DOTNET_INSTALL_SCRIPT"
    chmod +x "$DOTNET_INSTALL_SCRIPT"
    echo "✅ dotnet-install script downloaded"
fi

echo ""
echo "📋 Checking .NET version from global.json..."

# Determine .NET version from global.json file
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ -f "$DOTFILES_DIR/global.json" ]; then
    echo "📋 .NET configuration from global.json:"
    cat "$DOTFILES_DIR/global.json"
    
    # Extract SDK version from global.json
    SDK_VERSION=$(grep -o '"version"[[:space:]]*:[[:space:]]*"[^"]*"' "$DOTFILES_DIR/global.json" | cut -d'"' -f4)
    
    if [ -n "$SDK_VERSION" ]; then
        echo ""
        echo "📦 Installing .NET SDK $SDK_VERSION..."
        
        # Install specific SDK version using dotnet-install script
        "$DOTNET_INSTALL_SCRIPT" --version "$SDK_VERSION" --install-dir "$DOTNET_INSTALL_DIR"
        
        echo ""
        echo "✅ .NET SDK $SDK_VERSION installed"
    fi
    
    # Install additional common versions (optional)
    echo ""
    read -p "Install additional .NET SDK versions? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "📦 Installing common .NET SDK versions..."
        
        # .NET 8 LTS (supported until Nov 2026)
        echo "  Installing .NET 8.0 LTS..."
        "$DOTNET_INSTALL_SCRIPT" --channel 8.0 --install-dir "$DOTNET_INSTALL_DIR" || true
        
        # .NET 9 (latest)
        echo "  Installing .NET 9.0..."
        "$DOTNET_INSTALL_SCRIPT" --channel 9.0 --install-dir "$DOTNET_INSTALL_DIR" || true
        
        echo "✅ Additional SDK versions installed"
    fi
else
    echo "⚠️  No global.json file found, installing latest LTS..."
    "$DOTNET_INSTALL_SCRIPT" --channel LTS --install-dir "$DOTNET_INSTALL_DIR"
    echo "✅ .NET SDK LTS installed"
fi

# Configure .NET environment
echo ""
echo "📊 Current .NET configuration:"
if [ -f "$DOTNET_INSTALL_DIR/dotnet" ]; then
    echo "   .NET SDK:     $("$DOTNET_INSTALL_DIR/dotnet" --version 2>/dev/null || echo 'not found')"
    echo ""
    echo "   Installed SDKs:"
    "$DOTNET_INSTALL_DIR/dotnet" --list-sdks 2>/dev/null || echo "   None"
else
    echo "   .NET not found in $DOTNET_INSTALL_DIR"
fi
echo ""

echo "✅ .NET setup complete!"
echo ""
echo "📚 Quick Reference:"
echo ""
echo "   .NET Version Management:"
echo "      ~/.dotnet/dotnet --version           # Show current SDK version"
echo "      ~/.dotnet/dotnet --list-sdks         # List installed SDKs"
echo "      ~/.dotnet/dotnet-install.sh --version 8.0.100 --install-dir ~/.dotnet  # Install SDK 8.0.100"
echo "      ~/.dotnet/dotnet-install.sh --channel LTS --install-dir ~/.dotnet       # Install latest LTS"
echo ""
echo "   Project Management:"
echo "      dotnet new globaljson --sdk-version 10.0.100  # Create/update global.json"
echo "      dotnet new console                            # Create console app"
echo "      dotnet new webapi                             # Create Web API project"
echo "      dotnet build                                  # Build project"
echo "      dotnet run                                    # Run project"
echo ""
echo "💡 Tips:"
echo "   - Use global.json to pin SDK version for your project"
echo "   - Multiple SDK versions can coexist in ~/.dotnet"
echo "   - .NET automatically uses the version specified in global.json"
echo "   - Add to your PATH: export PATH=\"\$HOME/.dotnet:\$PATH\""
echo ""
