#!/usr/bin/env bash
# Setup VS Code configuration and extensions
# This script syncs VS Code settings and installs recommended extensions

set -e

echo "🚀 Setting up VS Code configuration..."

# Check if VS Code is installed
if ! command -v code &> /dev/null; then
    echo "❌ VS Code 'code' command not found"
    echo ""
    echo "Please install VS Code and enable the 'code' command:"
    echo "  1. Open VS Code"
    echo "  2. Press Cmd+Shift+P"
    echo "  3. Type 'shell command'"
    echo "  4. Select 'Install code command in PATH'"
    echo ""
    read -p "Install VS Code via Homebrew? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "📦 Installing VS Code..."
        brew install --cask visual-studio-code
        echo "✅ VS Code installed"
        echo ""
        echo "⚠️  Please restart your terminal and run this script again"
        exit 0
    else
        exit 1
    fi
fi

echo "✅ VS Code is installed ($(code --version | head -n 1))"
echo ""

# Determine dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VSCODE_CONFIG_DIR="$DOTFILES_DIR/vscode"

# Determine VS Code user settings directory
if [[ "$OSTYPE" == "darwin"* ]]; then
    VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    VSCODE_USER_DIR="$HOME/.config/Code/User"
else
    echo "❌ Unsupported operating system: $OSTYPE"
    exit 1
fi

# Create VS Code user directory if it doesn't exist
mkdir -p "$VSCODE_USER_DIR"
mkdir -p "$VSCODE_USER_DIR/snippets"

# Backup existing settings
echo "📦 Backing up existing VS Code configuration..."
BACKUP_DIR="$HOME/.vscode-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

if [ -f "$VSCODE_USER_DIR/settings.json" ]; then
    cp "$VSCODE_USER_DIR/settings.json" "$BACKUP_DIR/"
    echo "   ✓ settings.json backed up to $BACKUP_DIR"
fi

if [ -f "$VSCODE_USER_DIR/keybindings.json" ]; then
    cp "$VSCODE_USER_DIR/keybindings.json" "$BACKUP_DIR/"
    echo "   ✓ keybindings.json backed up to $BACKUP_DIR"
fi

# Symlink configuration files
echo ""
echo "🔗 Creating symlinks to dotfiles..."

# Settings
if [ -f "$VSCODE_CONFIG_DIR/settings.json" ]; then
    ln -sf "$VSCODE_CONFIG_DIR/settings.json" "$VSCODE_USER_DIR/settings.json"
    echo "   ✓ settings.json → $VSCODE_CONFIG_DIR/settings.json"
else
    echo "   ⚠️  settings.json not found in $VSCODE_CONFIG_DIR"
fi

# Keybindings
if [ -f "$VSCODE_CONFIG_DIR/keybindings.json" ]; then
    ln -sf "$VSCODE_CONFIG_DIR/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
    echo "   ✓ keybindings.json → $VSCODE_CONFIG_DIR/keybindings.json"
else
    echo "   ⚠️  keybindings.json not found in $VSCODE_CONFIG_DIR"
fi

# Snippets
if [ -f "$VSCODE_CONFIG_DIR/snippets.code-snippets" ]; then
    ln -sf "$VSCODE_CONFIG_DIR/snippets.code-snippets" "$VSCODE_USER_DIR/snippets/global.code-snippets"
    echo "   ✓ snippets.code-snippets → $VSCODE_CONFIG_DIR/snippets.code-snippets"
else
    echo "   ⚠️  snippets.code-snippets not found in $VSCODE_CONFIG_DIR"
fi

# Install extensions
echo ""
echo "📦 Installing VS Code extensions..."
echo ""

if [ -f "$VSCODE_CONFIG_DIR/extensions.txt" ]; then
    # Get currently installed extensions
    INSTALLED_EXTENSIONS=$(code --list-extensions)
    
    # Read extensions from file and install
    while IFS= read -r extension || [ -n "$extension" ]; do
        # Skip comments and empty lines
        [[ "$extension" =~ ^#.*$ ]] && continue
        [[ -z "$extension" ]] && continue
        
        # Check if already installed
        if echo "$INSTALLED_EXTENSIONS" | grep -qi "^${extension}$"; then
            echo "✅ $extension (already installed)"
        else
            echo "📦 Installing $extension..."
            if code --install-extension "$extension" --force > /dev/null 2>&1; then
                echo "✅ $extension installed"
            else
                echo "❌ Failed to install $extension"
            fi
        fi
    done < "$VSCODE_CONFIG_DIR/extensions.txt"
else
    echo "⚠️  extensions.txt not found in $VSCODE_CONFIG_DIR"
fi

echo ""
echo "✅ VS Code setup complete!"
echo ""
echo "📊 Configuration Summary:"
echo "   Settings:     $VSCODE_USER_DIR/settings.json"
echo "   Keybindings:  $VSCODE_USER_DIR/keybindings.json"
echo "   Snippets:     $VSCODE_USER_DIR/snippets/global.code-snippets"
echo "   Backup:       $BACKUP_DIR"
echo ""
echo "📚 Useful Commands:"
echo ""
echo "   code .                    # Open current directory"
echo "   code <file>               # Open file"
echo "   code --list-extensions    # List installed extensions"
echo "   code --diff <file1> <file2>  # Compare files"
echo ""
echo "💡 Tips:"
echo "   - Press Cmd+Shift+P to open command palette"
echo "   - Press Cmd+P to quick open files"
echo "   - Press Cmd+B to toggle sidebar"
echo "   - Press Ctrl+\` to toggle terminal"
echo ""
