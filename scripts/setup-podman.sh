#!/usr/bin/env bash
# Setup Podman as Docker replacement with compatibility mode
# This script installs Podman via Homebrew, enables Docker compatibility, and sets up docker-compose
# Note: Only Homebrew installation is used to avoid conflicts with standalone installers

set -e

echo "🚀 Setting up Podman with Docker compatibility..."

# Check if Podman is already installed
if command -v podman &> /dev/null; then
    echo "✅ Podman is already installed ($(podman --version))"
else
    echo "📦 Installing Podman via Homebrew..."
    brew install podman
    echo "✅ Podman installed successfully!"
fi

# Check if Podman machine exists
echo ""
echo "📋 Checking Podman machine..."
if podman machine list 2>/dev/null | grep -q "podman-machine-default"; then
    echo "✅ Podman machine already exists"
    
    # Check if machine is running
    if podman machine list | grep "podman-machine-default" | grep -q "Running"; then
        echo "✅ Podman machine is running"
    else
        echo "🔄 Starting Podman machine..."
        podman machine start
        echo "✅ Podman machine started"
    fi
else
    echo "📦 Initializing Podman machine..."
    podman machine init
    echo "🔄 Starting Podman machine..."
    podman machine start
    echo "✅ Podman machine initialized and started"
fi

# Enable Docker compatibility socket
echo ""
echo "🔧 Enabling Docker compatibility mode..."
if [ -S /var/run/docker.sock ] || [ -L /var/run/docker.sock ]; then
    echo "✅ Docker socket already exists"
else
    echo "📝 Docker socket will be created by Podman machine"
fi

# Check for docker-compose
echo ""
if command -v docker-compose &> /dev/null; then
    echo "✅ docker-compose is already installed ($(docker-compose --version))"
else
    echo "📦 Installing docker-compose via Homebrew..."
    brew install docker-compose
    echo "✅ docker-compose installed successfully!"
fi

# Check for podman-compose
echo ""
if command -v podman-compose &> /dev/null; then
    echo "✅ podman-compose is already installed ($(podman-compose --version))"
else
    echo "📦 Installing podman-compose via Homebrew..."
    brew install podman-compose
    echo "✅ podman-compose installed successfully!"
fi

# Set up Podman Docker socket helper
echo ""
echo "🔧 Configuring Podman Docker compatibility..."

# Check if podman-mac-helper is installed for Docker socket
if command -v podman-mac-helper &> /dev/null; then
    echo "✅ podman-mac-helper is installed"
    
    # Set up Docker socket
    if [ ! -S /var/run/docker.sock ]; then
        echo "📝 Setting up Docker socket symlink..."
        sudo podman-mac-helper install
        echo "✅ Docker socket configured"
    fi
else
    echo "💡 To enable Docker socket compatibility, you can run:"
    echo "   sudo podman-mac-helper install"
fi

echo ""
echo "📊 Current Podman configuration:"
echo "   Podman:         $(podman --version)"
echo "   docker-compose: $(docker-compose --version 2>/dev/null || echo 'not found')"
echo "   podman-compose: $(podman-compose --version 2>/dev/null || echo 'not found')"
echo ""
echo "   Podman machines:"
podman machine list
echo ""

# Verify Docker compatibility
echo "🧪 Testing Docker compatibility..."
if podman ps &> /dev/null; then
    echo "✅ Podman is working correctly"
    
    # Test if docker command works (via alias or socket)
    if command -v docker &> /dev/null && docker ps &> /dev/null 2>&1; then
        echo "✅ Docker command is working (via Podman)"
    else
        echo "💡 Docker command not available - aliases not loaded yet"
        echo "   Run: source ~/.zshrc"
    fi
else
    echo "⚠️  Podman machine might need restart"
fi

echo ""
echo "✅ Podman setup complete!"
echo ""
echo "📚 Quick Reference:"
echo ""
echo "   Container Management:"
echo "      podman ps                    # List containers"
echo "      podman images                # List images"
echo "      podman run -it alpine        # Run container"
echo ""
echo "   Machine Management:"
echo "      podman machine list          # List machines"
echo "      podman machine start         # Start machine"
echo "      podman machine stop          # Stop machine"
echo "      podman machine ssh           # SSH into machine"
echo ""
echo "   Docker Compatibility:"
echo "      docker ps                    # Works via alias to podman"
echo "      docker-compose up            # Works with Docker socket"
echo "      podman-compose up            # Native Podman compose"
echo ""
echo "💡 Tips:"
echo "   - Use 'docker' command (aliased to podman) for compatibility"
echo "   - Use 'podman-compose' for native Podman features"
echo "   - Use 'docker-compose' for existing Docker Compose files"
echo ""
