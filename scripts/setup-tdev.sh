#!/usr/bin/env bash
# Setup tdev (Talkdesk Developer CLI)
# Clones, installs, and links the tdev command globally

set -e

TDEV_REPO="git@github.com:Talkdesk/talkdesk-developer.git"
TDEV_DIR="$HOME/work/talkdesk/code/talkdesk-developer"

echo "🔧 Setting up tdev (Talkdesk Developer CLI)..."

# Check prerequisites
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is required. Install it first (setup-nvm.sh)"
    exit 1
fi

NODE_MAJOR=$(node -v | sed 's/v//' | cut -d. -f1)
if (( NODE_MAJOR < 20 )); then
    echo "❌ Node.js 20+ required (current: $(node -v))"
    exit 1
fi
echo "✅ Node.js $(node -v)"

if ! command -v git &> /dev/null; then
    echo "❌ Git is required"
    exit 1
fi

# Clone if not present
if [ -d "$TDEV_DIR" ]; then
    echo "✅ talkdesk-developer repo already exists at $TDEV_DIR"
    echo "   Pulling latest changes..."
    git -C "$TDEV_DIR" pull --ff-only 2>/dev/null || echo "   ⚠️  Could not pull (check branch status)"
else
    echo "📦 Cloning talkdesk-developer..."
    mkdir -p "$(dirname "$TDEV_DIR")"
    git clone "$TDEV_REPO" "$TDEV_DIR"
fi

# Install dependencies and link
echo "📦 Installing dependencies..."
cd "$TDEV_DIR"
npm install

echo "🔗 Linking tdev command globally..."
npm link

# Create global env directory
mkdir -p "$HOME/.talkdesk-developer"
if [ ! -f "$HOME/.talkdesk-developer/.env" ]; then
    touch "$HOME/.talkdesk-developer/.env"
    echo "   Created ~/.talkdesk-developer/.env (add stack-specific env vars here)"
fi

# Verify
if command -v tdev &> /dev/null; then
    echo ""
    echo "✅ tdev installed successfully!"
    echo ""
    echo "📋 Next steps:"
    echo "   1. source ~/.zshrc                              # Reload shell"
    echo "   2. tdev stack find                              # Browse available stacks"
    echo "   3. tdev stack add official/vscode --agent vscode    # Install VS Code stack"
    echo ""
    echo "   For global install, add -g flag:"
    echo "   tdev stack add official/vscode --agent vscode -g"
else
    echo ""
    echo "⚠️  tdev command not found in PATH. Try: source ~/.zshrc"
fi
