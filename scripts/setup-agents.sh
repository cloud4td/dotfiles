#!/bin/bash
# Setup AI tools: MCP servers, Claude Code settings, Copilot memory
# Unified configuration for VS Code (Copilot), Claude Code, and Claude Desktop

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
MCP_TEMPLATE="$DOTFILES_DIR/agents/mcp.json.example"

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
# Homebrew PATH for GUI apps (ensures npx/uvx available to MCP)
# ============================================================

setup_homebrew_path() {
    echo ""
    echo "━━━ Homebrew PATH (GUI apps) ━━━"
    local paths_file="/etc/paths.d/homebrew"
    if [ -f "$paths_file" ] && grep -q "/opt/homebrew/bin" "$paths_file" 2>/dev/null; then
        echo "   ✅ Already configured: $paths_file"
        return
    fi
    echo "   MCP servers need Homebrew tools (npx, uvx) in PATH."
    echo "   This adds /opt/homebrew/bin to the system PATH for GUI apps."
    echo "   Requires sudo to write to $paths_file"
    read -p "   Apply? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo '/opt/homebrew/bin' | sudo tee "$paths_file" > /dev/null
        echo '/opt/homebrew/sbin' | sudo tee -a "$paths_file" > /dev/null
        echo "   ✅ Created $paths_file (restart VS Code/Claude to take effect)"
    else
        echo "   ⏭️  Skipped"
    fi
}

# ============================================================
# Helper: show diff between current and new content, ask to proceed
# Usage: confirm_overwrite <current_file> <new_file_or_content> [label]
# Returns 0 if user confirms, 1 if skipped
# ============================================================

show_diff_and_confirm() {
    local current="$1"
    local new="$2"
    local label="${3:-file}"

    echo ""
    echo "   📋 Diff ($label):"
    echo "   ─────────────────────────────"
    diff --color=auto -u "$current" "$new" 2>/dev/null | head -40 | sed 's/^/   /'
    if [ "${PIPESTATUS[0]}" -eq 0 ]; then
        echo "   (no differences)"
        return 1
    fi
    echo "   ─────────────────────────────"
    read -p "   Apply changes? (y/N): " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

# For symlinks: compare where it currently points vs new target
show_symlink_diff() {
    local current_link="$1"
    local new_source="$2"
    local label="${3:-symlink}"

    local current_target
    current_target=$(readlink "$current_link" 2>/dev/null || echo "(not a symlink)")

    echo ""
    echo "   📋 Symlink diff ($label):"
    echo "   ─────────────────────────────"
    echo "   current → $current_target"
    echo "   new     → $new_source"

    if [ -f "$current_link" ] && [ -f "$new_source" ]; then
        local content_diff
        content_diff=$(diff --color=auto -u "$current_link" "$new_source" 2>/dev/null | head -30)
        if [ -n "$content_diff" ]; then
            echo ""
            echo "   Content diff:"
            echo "$content_diff" | sed 's/^/   /'
        fi
    fi
    echo "   ─────────────────────────────"
    read -p "   Apply changes? (y/N): " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

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
        local new_content
        new_content=$(jq -n --argjson servers "$SERVERS" '{"servers": $servers, "inputs": []}')
        local tmpfile
        tmpfile=$(mktemp)
        echo "$new_content" > "$tmpfile"
        if show_diff_and_confirm "$VSCODE_MCP_TARGET" "$tmpfile" "VS Code mcp.json"; then
            cp "$VSCODE_MCP_TARGET" "$VSCODE_MCP_TARGET.backup.$(date +%Y%m%d_%H%M%S)"
            mv "$tmpfile" "$VSCODE_MCP_TARGET"
            echo "   ✅ VS Code mcp.json updated"
        else
            rm -f "$tmpfile"
            echo "   ⏭️  Skipped"
        fi
    else
        jq -n --argjson servers "$SERVERS" '{"servers": $servers, "inputs": []}' > "$VSCODE_MCP_TARGET"
        echo "   ✅ VS Code mcp.json created"
    fi

    # --- Claude Code ---
    echo ""
    echo "📦 Claude Code MCP..."
    if [ -f "$CLAUDE_CODE_CONFIG" ]; then
        local new_claude
        new_claude=$(jq --argjson servers "$SERVERS" '.mcpServers = $servers' "$CLAUDE_CODE_CONFIG")
        local tmpfile2
        tmpfile2=$(mktemp)
        echo "$new_claude" > "$tmpfile2"
        if show_diff_and_confirm "$CLAUDE_CODE_CONFIG" "$tmpfile2" "~/.claude.json"; then
            cp "$CLAUDE_CODE_CONFIG" "$CLAUDE_CODE_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"
            mv "$tmpfile2" "$CLAUDE_CODE_CONFIG"
            echo "   ✅ ~/.claude.json updated"
        else
            rm -f "$tmpfile2"
            echo "   ⏭️  Skipped"
        fi
    else
        jq -n --argjson servers "$SERVERS" '{"mcpServers": $servers}' > "$CLAUDE_CODE_CONFIG"
        echo "   ✅ ~/.claude.json created"
    fi

    # --- Claude Desktop ---
    echo ""
    echo "📦 Claude Desktop MCP..."
    mkdir -p "$CLAUDE_DESKTOP_DIR"
    if [ -f "$CLAUDE_DESKTOP_CONFIG" ]; then
        local new_desktop
        new_desktop=$(jq --argjson servers "$SERVERS" '.mcpServers = $servers' "$CLAUDE_DESKTOP_CONFIG")
        local tmpfile3
        tmpfile3=$(mktemp)
        echo "$new_desktop" > "$tmpfile3"
        if show_diff_and_confirm "$CLAUDE_DESKTOP_CONFIG" "$tmpfile3" "Claude Desktop config"; then
            cp "$CLAUDE_DESKTOP_CONFIG" "$CLAUDE_DESKTOP_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"
            mv "$tmpfile3" "$CLAUDE_DESKTOP_CONFIG"
            echo "   ✅ Claude Desktop config updated"
        else
            rm -f "$tmpfile3"
            echo "   ⏭️  Skipped"
        fi
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
    local source="$DOTFILES_DIR/agents/claude/settings.json"
    mkdir -p "$CLAUDE_CODE_DIR"

    if [ ! -f "$source" ]; then
        echo "   ⚠️  agents/claude/settings.json not found in dotfiles, skipping"
        return
    fi

    if [ -L "$CLAUDE_CODE_SETTINGS" ]; then
        local current_target
        current_target=$(readlink "$CLAUDE_CODE_SETTINGS")
        if [ "$current_target" = "$source" ]; then
            echo "   ✅ Already linked: ~/.claude/settings.json"
            return
        fi
        if ! show_symlink_diff "$CLAUDE_CODE_SETTINGS" "$source" "~/.claude/settings.json"; then
            echo "   ⏭️  Skipped"
            return
        fi
        rm "$CLAUDE_CODE_SETTINGS"
    elif [ -f "$CLAUDE_CODE_SETTINGS" ]; then
        if ! show_diff_and_confirm "$CLAUDE_CODE_SETTINGS" "$source" "~/.claude/settings.json"; then
            echo "   ⏭️  Skipped"
            return
        fi
        mv "$CLAUDE_CODE_SETTINGS" "${CLAUDE_CODE_SETTINGS}.backup.$(date +%Y%m%d_%H%M%S)"
        echo "   📦 Backed up existing settings.json"
    fi

    ln -sf "$source" "$CLAUDE_CODE_SETTINGS"
    echo "   ✅ Linked: ~/.claude/settings.json -> dotfiles/agents/claude/settings.json"
    echo "   📋 Includes: allowed commands, denied commands, plugins"
}

# ============================================================
# User-Level Instructions (AGENTS.md → Copilot + Claude)
# ============================================================

setup_user_instructions() {
    echo ""
    echo "━━━ User-Level Instructions ━━━"
    local source="$DOTFILES_DIR/agents/AGENTS.md"

    if [ ! -f "$source" ]; then
        echo "   ⚠️  AGENTS.md not found in dotfiles, skipping"
        return
    fi

    # VS Code Copilot — user.instructions.md
    if [[ "$OSTYPE" == "darwin"* ]]; then
        local prompts_dir="$VSCODE_USER_DIR/prompts"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        local prompts_dir="$HOME/.config/Code/User/prompts"
    fi
    local copilot_target="$prompts_dir/user.instructions.md"
    mkdir -p "$prompts_dir"

    if [ -L "$copilot_target" ]; then
        local ct
        ct=$(readlink "$copilot_target")
        if [ "$ct" = "$source" ]; then
            echo "   ✅ Copilot: Already linked"
        else
            if show_symlink_diff "$copilot_target" "$source" "Copilot user.instructions.md"; then
                rm "$copilot_target"
                ln -sf "$source" "$copilot_target"
                echo "   ✅ Copilot: Re-linked user.instructions.md"
            else
                echo "   ⏭️  Copilot: Skipped"
            fi
        fi
    elif [ -f "$copilot_target" ]; then
        if show_diff_and_confirm "$copilot_target" "$source" "Copilot user.instructions.md"; then
            mv "$copilot_target" "${copilot_target}.backup.$(date +%Y%m%d_%H%M%S)"
            ln -sf "$source" "$copilot_target"
            echo "   ✅ Copilot: Linked user.instructions.md (backed up old)"
        else
            echo "   ⏭️  Copilot: Skipped"
        fi
    else
        ln -sf "$source" "$copilot_target"
        echo "   ✅ Copilot: Linked user.instructions.md"
    fi

    # Claude Code — ~/.claude.md
    local claude_target="$HOME/.claude.md"
    if [ -L "$claude_target" ]; then
        local ct2
        ct2=$(readlink "$claude_target")
        if [ "$ct2" = "$source" ]; then
            echo "   ✅ Claude: Already linked"
        else
            if show_symlink_diff "$claude_target" "$source" "Claude ~/.claude.md"; then
                rm "$claude_target"
                ln -sf "$source" "$claude_target"
                echo "   ✅ Claude: Re-linked ~/.claude.md"
            else
                echo "   ⏭️  Claude: Skipped"
            fi
        fi
    elif [ -f "$claude_target" ]; then
        if show_diff_and_confirm "$claude_target" "$source" "Claude ~/.claude.md"; then
            mv "$claude_target" "${claude_target}.backup.$(date +%Y%m%d_%H%M%S)"
            ln -sf "$source" "$claude_target"
            echo "   ✅ Claude: Linked ~/.claude.md (backed up old)"
        else
            echo "   ⏭️  Claude: Skipped"
        fi
    else
        ln -sf "$source" "$claude_target"
        echo "   ✅ Claude: Linked ~/.claude.md"
    fi
}

# ============================================================
# Copilot Memory Directory
# ============================================================

setup_copilot_memory() {
    echo ""
    echo "━━━ Copilot Memory ━━━"
    local target="$COPILOT_MEMORY_PARENT/memories"
    local source="$DOTFILES_DIR/agents/copilot/memories"
    mkdir -p "$COPILOT_MEMORY_PARENT"

    if [ -L "$target" ]; then
        local current_target
        current_target=$(readlink "$target")
        if [ "$current_target" = "$source" ]; then
            echo "   ✅ Already linked: $target"
            return
        fi
        if show_symlink_diff "$target" "$source" "Copilot memories"; then
            rm "$target"
        else
            echo "   ⏭️  Skipped"
            return
        fi
    elif [ -d "$target" ]; then
        echo "   ⚠️  memories/ is a real directory, not a symlink"
        echo "   new → $source"
        read -p "   Backup and replace? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "   ⏭️  Skipped"
            return
        fi
        mv "$target" "${target}.backup.$(date +%Y%m%d_%H%M%S)"
        echo "   📦 Backed up existing memories directory"
    fi

    ln -sf "$source" "$target"
    echo "   ✅ Linked: memories -> dotfiles/agents/copilot/memories"
}

# ============================================================
# Main
# ============================================================

echo ""
echo "What do you want to set up?"
echo "  1) MCP servers only"
echo "  2) Claude Code agent settings only"
echo "  3) Copilot memory only"
echo "  4) User-level instructions (AGENTS.md) only"
echo "  5) Homebrew PATH for GUI apps only"
echo "  6) All (default)"
read -p "Choice [6]: " choice
choice=${choice:-6}

case $choice in
    1) setup_mcp ;;
    2) setup_claude_code_settings ;;
    3) setup_copilot_memory ;;
    4) setup_user_instructions ;;
    5) setup_homebrew_path ;;
    6) setup_homebrew_path; setup_mcp; setup_claude_code_settings; setup_copilot_memory; setup_user_instructions ;;
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
echo "   Copilot instructions:  ~/Library/Application Support/Code/User/prompts/user.instructions.md (symlink)"
echo "   Copilot memory:        dotfiles/agents/copilot/memories/ (symlink)"
echo "   Claude Code MCP:       ~/.claude.json"
echo "   Claude Code settings:  ~/.claude/settings.json (symlink)"
echo "   Claude Code instructions: ~/.claude.md (symlink)"
echo "   Claude Desktop:        ~/Library/Application Support/Claude/claude_desktop_config.json"
echo "   Source of truth:       dotfiles/agents/AGENTS.md"
