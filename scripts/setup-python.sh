#!/usr/bin/env bash
# Setup Python development environment with uv and Poetry
# This script installs uv, Poetry, and Python versions managed by uv

set -e

echo "🚀 Setting up Python development environment..."

# Check and install uv
if command -v uv &> /dev/null; then
    echo "✅ uv is already installed ($(uv --version))"
else
    echo "📦 Installing uv via Homebrew..."
    brew install uv
    echo "✅ uv installed successfully!"
fi

# Check and install Poetry
if command -v poetry &> /dev/null; then
    echo "✅ Poetry is already installed ($(poetry --version))"
else
    echo "📦 Installing Poetry via Homebrew..."
    brew install poetry
    echo "✅ Poetry installed successfully!"
fi

echo ""
echo "📋 Checking Python versions from .python-version..."

# Determine Python version from .python-version file
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ -f "$DOTFILES_DIR/.python-version" ]; then
    # Display Python versions to be installed
    echo "📋 Python versions from .python-version:"
    grep -v '^[[:space:]]*$' "$DOTFILES_DIR/.python-version" | grep -v '^#' | while read -r version; do
        [ -n "$version" ] && echo "   - $version"
    done
    
    # Install Python versions via uv by changing to dotfiles directory
    # This allows uv to detect and use .python-version automatically
    echo ""
    echo "📦 Installing Python versions via uv..."
    cd "$DOTFILES_DIR"
    uv python install
    
    echo ""
    echo "✅ All Python versions installed and configured"
else
    echo "⚠️  No .python-version file found, skipping Python installation"
    echo "💡 Create .python-version file with: uv python pin 3.12"
    exit 0
fi

# Add uv Python to PATH if not already
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

echo ""
echo "📊 Current Python configuration:"
echo "   uv:      $(uv --version)"
echo "   Poetry:  $(poetry --version)"
echo ""
echo "   Installed Python versions (via uv):"
uv python list
echo ""

# Configure Poetry (optional but recommended)
echo "🔧 Configuring Poetry..."
poetry config virtualenvs.in-project true         # Create .venv in project directory
poetry config virtualenvs.use-poetry-python false # Use system/uv Python
poetry config installer.parallel true             # Faster installation
echo "   ✓ virtualenvs.in-project = true"
echo "   ✓ virtualenvs.use-poetry-python = false"
echo "   ✓ installer.parallel = true"

echo ""
echo "✅ Python environment setup complete!"
echo ""
echo "📚 Quick Reference:"
echo ""
echo "   Python Version Management:"
echo "      uv python list                # List installed versions"
echo "      uv python install 3.12        # Install Python 3.12"
echo "      uv python install             # Install versions from .python-version"
echo "      uv python pin 3.12            # Set project version"
echo ""
echo "   Package Management:"
echo "      poetry new myproject          # Create Poetry project"
echo "      poetry add requests           # Add dependency"
echo ""
echo "      uv init myproject             # Create uv project (faster)"
echo "      uv add requests               # Add dependency"
echo "      uv sync                       # Install dependencies"
echo ""
