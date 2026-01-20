#!/bin/bash
# Setup VS Code MCP configuration

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
MCP_TEMPLATE="$DOTFILES_DIR/vscode/mcp.json.example"
MCP_TARGET="$VSCODE_USER_DIR/mcp.json"

echo "🔧 Setting up VS Code MCP configuration..."

# Check if template exists
if [ ! -f "$MCP_TEMPLATE" ]; then
    echo "❌ Error: mcp.json.example not found in $DOTFILES_DIR/vscode/"
    exit 1
fi

# Create VS Code user directory if it doesn't exist
mkdir -p "$VSCODE_USER_DIR"

# Check if mcp.json already exists
if [ -f "$MCP_TARGET" ]; then
    echo "⚠️  mcp.json already exists at $MCP_TARGET"
    read -p "Do you want to backup and replace it? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp "$MCP_TARGET" "$MCP_TARGET.backup.$(date +%Y%m%d_%H%M%S)"
        echo "✅ Backup created"
    else
        echo "ℹ️  Skipping mcp.json setup"
        exit 0
    fi
fi

# Copy template and substitute environment variables
echo "📝 Creating mcp.json from template..."

# Use envsubst to replace environment variables
if command -v envsubst >/dev/null 2>&1; then
    envsubst < "$MCP_TEMPLATE" > "$MCP_TARGET"
    echo "✅ mcp.json created with environment variables substituted"
else
    # Fallback: just copy the template
    cp "$MCP_TEMPLATE" "$MCP_TARGET"
    echo "⚠️  envsubst not found, copied template as-is"
    echo "ℹ️  You'll need to manually replace \$JIRA_API_TOKEN and \$GITHUB_TOKEN"
fi

echo ""
echo "✅ MCP configuration setup complete!"
echo ""
echo "📋 Next steps:"
echo "   1. Make sure your secrets.zsh is loaded: source ~/.zshrc"
echo "   2. Restart VS Code to load the MCP configuration"
echo "   3. Verify tokens are set:"
echo "      echo \$JIRA_API_TOKEN"
echo "      echo \$GITHUB_TOKEN"
