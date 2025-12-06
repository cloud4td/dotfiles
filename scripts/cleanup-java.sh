#!/usr/bin/env bash
# Cleanup old Java installations on macOS
# This script helps identify and optionally remove Java versions installed outside of SDKMAN

set -e

echo "🔍 Scanning for Java installations on your system..."
echo ""

# Function to get size of directory
get_size() {
    du -sh "$1" 2>/dev/null | awk '{print $1}'
}

# Find all Java installations
JAVA_DIRS=()
TOTAL_SIZE=0

# Common Java installation locations on macOS
LOCATIONS=(
    "$HOME/Library/Java/JavaVirtualMachines"
    "/Library/Java/JavaVirtualMachines"
    "/System/Library/Java/JavaVirtualMachines"
)

echo "📂 Found Java installations:"
echo ""

for location in "${LOCATIONS[@]}"; do
    if [ -d "$location" ]; then
        for java_dir in "$location"/*; do
            if [ -d "$java_dir" ]; then
                size=$(get_size "$java_dir")
                version=$(basename "$java_dir")
                JAVA_DIRS+=("$java_dir")
                echo "  📦 $version"
                echo "     Location: $java_dir"
                echo "     Size: $size"
                echo ""
            fi
        done
    fi
done

# Check SDKMAN installations
if [ -d "$HOME/.sdkman/candidates/java" ]; then
    echo "📂 SDKMAN Java installations (will NOT be removed):"
    echo ""
    for java_dir in "$HOME/.sdkman/candidates/java"/*; do
        if [ -d "$java_dir" ] && [ "$(basename "$java_dir")" != "current" ]; then
            size=$(get_size "$java_dir")
            version=$(basename "$java_dir")
            echo "  ✅ $version"
            echo "     Location: $java_dir"
            echo "     Size: $size"
            echo ""
        fi
    done
fi

# If no Java installations found
if [ ${#JAVA_DIRS[@]} -eq 0 ]; then
    echo "✅ No Java installations found outside of SDKMAN"
    exit 0
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "⚠️  Found ${#JAVA_DIRS[@]} Java installation(s) outside of SDKMAN"
echo ""
echo "💡 Options:"
echo "  1. Remove all non-SDKMAN Java installations"
echo "  2. Select specific versions to remove"
echo "  3. Exit without changes"
echo ""
read -p "Choose an option (1-3): " choice

case $choice in
    1)
        echo ""
        echo "🗑️  Removing all non-SDKMAN Java installations..."
        for java_dir in "${JAVA_DIRS[@]}"; do
            echo "  Removing: $java_dir"
            sudo rm -rf "$java_dir"
        done
        echo "✅ All non-SDKMAN Java installations removed!"
        ;;
    2)
        echo ""
        echo "Select versions to remove (enter numbers separated by space):"
        for i in "${!JAVA_DIRS[@]}"; do
            echo "  $((i+1)). $(basename "${JAVA_DIRS[$i]}") - ${JAVA_DIRS[$i]}"
        done
        echo ""
        read -p "Enter selection: " selections
        
        echo ""
        echo "🗑️  Removing selected Java installations..."
        for num in $selections; do
            idx=$((num-1))
            if [ $idx -ge 0 ] && [ $idx -lt ${#JAVA_DIRS[@]} ]; then
                java_dir="${JAVA_DIRS[$idx]}"
                echo "  Removing: $java_dir"
                sudo rm -rf "$java_dir"
            fi
        done
        echo "✅ Selected Java installations removed!"
        ;;
    3)
        echo ""
        echo "👋 No changes made. Exiting..."
        exit 0
        ;;
    *)
        echo ""
        echo "❌ Invalid option. Exiting..."
        exit 1
        ;;
esac

echo ""
echo "🧹 Cleanup complete!"
echo ""
echo "💡 To verify current Java:"
echo "  java -version"
echo "  echo \$JAVA_HOME"
echo ""
echo "💡 To manage Java versions with SDKMAN:"
echo "  sdk list java              - List available versions"
echo "  sdk install java <version> - Install a version"
echo "  sdk default java <version> - Set default version"
