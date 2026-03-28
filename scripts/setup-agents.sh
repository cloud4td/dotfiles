#!/bin/bash
# Setup AI tools: MCP servers, Claude Code settings, Copilot memory
# Unified configuration for VS Code (Copilot), Claude Code, and Claude Desktop

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
MCP_TEMPLATE="$DOTFILES_DIR/vscode/mcp.json.example"

# Target locations
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
VSCODE_MCP_TARGET="$VSCODE_USER_DIR/mcp.json"
CLAUDE_CODE_CONFIG="$HOME/.claude.json"
CLAUDE_CODE_DIR="$HOME/.claude"
CLAUDE_CODE_SETTINGS="$CLAUDE_CODE_DIR/settings.json"
CLAUDE_DESKTOP_DIR="$HOME/Library/Application Support/Claude"
CLAUDE_DESKTOP_CONFIG="$CLAUDE_DESKTOP_DIR/claude_desktop_config.json"
COPILOT_MEMORY_PARENT="$VSCODE_USER_DIR/globalStorage/github.copilot-chat/memory-tool"

echo "🤖 Setting up AI tools configuration..."

# ============================================================
# MCP Servers
# ============================================================

setup_mcp() {
    echo ""
    echo "━━━ MCP Servers ━━━"

    # Check if template exists
    if [ ! -f "$MCP_TEMPLATE" ]; then
        echo "❌ Error: mcp.json.example not found in $DOTFILES_DIR/vscode/"
        return 1
    fi

    # Read server definitions from template
    local SERVERS
    SERVERS=$(cat "$MCP_TEMPLATE")

    # --- VS Code ---
    echo ""
    echo "📦 VS Code (Copilot) MCP..."
    mkdir -p "$VSCODE_USER_DIR"
    if [ -f "$VSCODE_MCP_TARGET" ]; then
        echo "   ⚠️  mcp.json already exists"
        read -p "   Backup and replace? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "   ⏭️  Skipped"
        else
            cp "$VSCODE_MCP_TARGET" "$VSCODE_MCP_TARGET.backup.$(date +%Y%m%d_%H%M%S)"
            jq -n --argjson servers "$SERVERS" '{"servers": $servers, "inputs": []}' > "$VSCODE_MCP_TARGET"
            echo "   ✅ VS Code mcp.json updated"
        fi
    else
        jq -n --argjson servers "$SERVERS" '{"servers": $servers, "inputs": []}' > "$VSCODE_MCP_TARGET"
        echo "   ✅ VS Code mcp.json created"
    fi

    # --- Claude Code ---
    echo ""
    echo "📦 Claude Code MCP..."
    if [ -f "$CLAUDE_CODE_CONFIG" ]; then
        cp "$CLAUDE_CODE_CONFIG" "$CLAUDE_CODE_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"
        jq --argjson servers "$SERVERS" '.mcpServers = $servers' "$CLAUDE_CODE_CONFIG" > "$CLAUDE_CODE_CONFIG.tmp" \
            && mv "$CLAUDE_CODE_CONFIG.tmp" "$CLAUDE_CODE_CONFIG"
        echo "   ✅ ~/.claude.json updated"
    else
        jq -n --argjson servers "$SERVERS" '{"mcpServers": $servers}' > "$CLAUDE_CODE_CONFIG"
        echo "   ✅ ~/.claude.json created"
    fi

    # --- Claude Desktop ---
    echo ""
    echo "📦 Claude Desktop MCP..."
    mkdir -p "$CLAUDE_DESKTOP_DIR"
    if [ -f "$CLAUDE_DESKTOP_CONFIG" ]; then
        cp "$CLAUDE_DESKTOP_CONFIG" "$CLAUDE_DESKTOP_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"
        jq --argjson servers "$SERVERS" '.mcpServers = $servers' "$CLAUDE_DESKTOP_CONFIG" > "$CLAUDE_DESKTOP_CONFIG.tmp" \
            && mv "$CLAUDE_DESKTOP_CONFIG.tmp" "$CLAUDE_DESKTOP_CONFIG"
        echo "   ✅ Claude Desktop config updated"
    else
        jq -n --argjson servers "$SERVERS" '{"mcpServers": $servers}' > "$CLAUDE_DESKTOP_CONFIG"
        echo "   ✅ Claude Desktop config created"
    fi
}

# ============================================================
# Claude Code Agent Settings (permissions, plugins)
# ============================================================

setup_claude_code_settings() {
    echo ""
    echo "━━━ Claude Code Agent Settings ━━━"
    local source="$DOTFILES_DIR/claude/settings.json"
    mkdir -p "$CLAUDE_CODE_DIR"

    if [ ! -f "$source" ]; then
        echo "   ⚠️  claude/settings.json not found in dotfiles, skipping"
        return
    fi

    if [ -L "$CLAUDE_CODE_SETTINGS" ]; then
        local current_target
        current_target=$(readlink "$CLAUDE_CODE_SETTINGS")
        if [ "$current_target" = "$source" ]; then
            echo "   ✅ Already linked: ~/.claude/settings.json"
            return
        fi
        rm "$CLAUDE_CODE_SETTINGS"
    elif [ -f "$CLAUDE_CODE_SETTINGS" ]; then
        mv "$CLAUDE_CODE_SETTINGS" "${CLAUDE_CODE_SETTINGS}.backup.$(date +%Y%m%d_%H%M%S)"
        echo "   📦 Backed up existing settings.json"
    fi

    ln -sf "$source" "$CLAUDE_CODE_SETTINGS"
    echo "   ✅ Linked: ~/.claude/settings.json -> dotfiles/claude/settings.json"
    echo "   📋 Includes: allowed commands, denied commands, plugins"
}

# ============================================================
# Copilot Memory Directory
# ============================================================

setup_copilot_memory() {
    echo ""
    echo "━━━ Copilot Memory ━━━"
    local target="$COPILOT_MEMORY_PARENT/memories"
    mkdir -p "$COPILOT_MEMORY_PARENT"

    if [ -L "$target" ]; then
        echo "   ✅ Already linked: $target"
        return
    fi

    if [ -d "$target" ]; then
        mv "$target" "${target}.backup.$(date +%Y%m%d_%H%M%S)"
        echo "   📦 Backed up existing memories directory"
    fi

    ln -sf "$DOTFILES_DIR/memories" "$target"
    echo "   ✅ Linked: memories -> dotfiles/memories"
}

# ============================================================
# Main
# ============================================================

echo ""
echo "What do you want to set up?"
echo "  1) MCP servers only"
echo "  2) Claude Code agent settings only"
echo "  3) Copilot memory only"
echo "  4) All (default)"
read -p "Choice [4]: " choice
choice=${choice:-4}

case $choice in
    1) setup_mcp ;;
    2) setup_claude_code_settings ;;
    3) setup_copilot_memory ;;
    4) setup_mcp; setup_claude_code_settings; setup_copilot_memory ;;
    *) echo "❌ Invalid choice"; exit 1 ;;
esac

echo ""
echo "✅ AI tools setup complete!"
echo ""
echo "📋 Next steps:"
echo "   1. Make sure your secrets.zsh is loaded: source ~/.zshrc"
echo "   2. Restart VS Code / Claude Code / Claude Desktop"
echo "   3. Verify tokens: echo \$ATLASSIAN_API_TOKEN"
echo ""
echo "📍 Config locations:"
echo "   VS Code MCP:           ~/Library/Application Support/Code/User/mcp.json"
echo "   VS Code settings:      ~/Library/Application Support/Code/User/settings.json (symlink)"
echo "   Claude Code MCP:       ~/.claude.json"
echo "   Claude Code settings:  ~/.claude/settings.json (symlink)"
echo "   Claude Desktop:        ~/Library/Application Support/Claude/claude_desktop_config.json"
echo "   Copilot memory:        dotfiles/memories/ (symlink)"
