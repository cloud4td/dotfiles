#!/bin/bash
# Setup MCP configuration for VS Code and Claude Code

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
MCP_TEMPLATE="$DOTFILES_DIR/vscode/mcp.json.example"

# Target locations
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
VSCODE_MCP_TARGET="$VSCODE_USER_DIR/mcp.json"
CLAUDE_CONFIG="$HOME/.claude.json"

echo "🔧 Setting up MCP configuration..."

# Check if template exists
if [ ! -f "$MCP_TEMPLATE" ]; then
    echo "❌ Error: mcp.json.example not found in $DOTFILES_DIR/vscode/"
    exit 1
fi

# Read server definitions from template
SERVERS=$(cat "$MCP_TEMPLATE")

# --- VS Code ---
setup_vscode() {
    echo ""
    echo "📦 VS Code MCP setup..."
    mkdir -p "$VSCODE_USER_DIR"

    if [ -f "$VSCODE_MCP_TARGET" ]; then
        echo "⚠️  mcp.json already exists at $VSCODE_MCP_TARGET"
        read -p "   Backup and replace? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "   ⏭️  Skipped VS Code"
            return
        fi
        cp "$VSCODE_MCP_TARGET" "$VSCODE_MCP_TARGET.backup.$(date +%Y%m%d_%H%M%S)"
        echo "   ✅ Backup created"
    fi

    # Wrap with "servers" key for VS Code format
    jq -n --argjson servers "$SERVERS" '{"servers": $servers, "inputs": []}' > "$VSCODE_MCP_TARGET"
    echo "   ✅ VS Code mcp.json created"
}

# --- Claude Code ---
setup_claude() {
    echo ""
    echo "📦 Claude Code MCP setup..."

    if [ -f "$CLAUDE_CONFIG" ]; then
        # Merge mcpServers into existing config
        echo "   ℹ️  Merging into existing ~/.claude.json"
        cp "$CLAUDE_CONFIG" "$CLAUDE_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"
        jq --argjson servers "$SERVERS" '.mcpServers = $servers' "$CLAUDE_CONFIG.backup."* 2>/dev/null | head -1 > /dev/null || true
        jq --argjson servers "$SERVERS" '.mcpServers = $servers' "$CLAUDE_CONFIG" > "$CLAUDE_CONFIG.tmp" \
            && mv "$CLAUDE_CONFIG.tmp" "$CLAUDE_CONFIG"
        echo "   ✅ Claude Code config updated (backup created)"
    else
        # Create new config
        jq -n --argjson servers "$SERVERS" '{"mcpServers": $servers}' > "$CLAUDE_CONFIG"
        echo "   ✅ Claude Code config created at ~/.claude.json"
    fi
}

# --- Main ---
echo ""
echo "Which tools do you want to configure?"
echo "  1) VS Code only"
echo "  2) Claude Code only"
echo "  3) Both (default)"
read -p "Choice [3]: " choice
choice=${choice:-3}

case $choice in
    1) setup_vscode ;;
    2) setup_claude ;;
    3) setup_vscode; setup_claude ;;
    *) echo "❌ Invalid choice"; exit 1 ;;
esac

echo ""
echo "✅ MCP configuration setup complete!"
echo ""
echo "📋 Next steps:"
echo "   1. Make sure your secrets.zsh is loaded: source ~/.zshrc"
echo "   2. Restart VS Code / Claude Code to load the MCP configuration"
echo "   3. Verify tokens are set:"
echo "      echo \$ATLASSIAN_API_TOKEN"
