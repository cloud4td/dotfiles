# Custom Commands and Functions
# These custom commands can be safely committed to git

# ------------------------------------------
# Environment Switching Commands
# ------------------------------------------

# senv - Switch SDKMAN environment from .sdkmanrc
# Usage: senv          (load .sdkmanrc in current or parent dirs)
#        senv <path>   (load .sdkmanrc from specific directory)
function senv() {
    local rcfile
    if [[ -n "$1" ]]; then
        rcfile="$1/.sdkmanrc"
    else
        # Walk up to find .sdkmanrc
        local dir="$PWD"
        while [[ "$dir" != "/" ]]; do
            if [[ -f "$dir/.sdkmanrc" ]]; then
                rcfile="$dir/.sdkmanrc"
                break
            fi
            dir="$(dirname "$dir")"
        done
    fi
    if [[ -z "$rcfile" || ! -f "$rcfile" ]]; then
        echo "No .sdkmanrc found"
        return 1
    fi
    echo "Loading $rcfile"
    sdk env install "$rcfile" 2>/dev/null
    sdk env "$rcfile"
}

# nenv - Switch Node.js version from .node-version / .nvmrc
# Usage: nenv          (auto-detect version file in current dir)
#        nenv 22       (switch to Node 22)
#        nenv 20.11.0  (switch to specific version)
function nenv() {
    if [[ -n "$1" ]]; then
        nvm install "$1" && nvm use "$1"
    else
        # Look for version file
        if [[ -f ".nvmrc" || -f ".node-version" ]]; then
            nvm install && nvm use
        else
            echo "No .nvmrc or .node-version found. Usage: nenv <version>"
            nvm ls
            return 1
        fi
    fi
}

# penv - Switch Python version
# Usage: penv 3.12     (switch to Python 3.12)
#        penv          (show available versions)
function penv() {
    if [[ -n "$1" ]]; then
        uv python pin "$1"
    else
        echo "Available Python versions:"
        uv python list --only-installed
    fi
}

# jenv - Quick switch individual SDKMAN tool
# Usage: jenv java 21.0.3-tem
#        jenv maven 3.9.6
function jenv() {
    if [[ $# -lt 2 ]]; then
        echo "Usage: jenv <candidate> <version>"
        echo "Examples: jenv java 21.0.3-tem | jenv maven 3.9.6"
        return 1
    fi
    sdk use "$1" "$2"
}

# envs - Show current environment versions at a glance
function envs() {
    echo "Java:   $(java -version 2>&1 | head -1)"
    echo "Maven:  $(mvn --version 2>/dev/null | head -1 || echo 'not found')"
    echo "Gradle: $(gradle --version 2>/dev/null | grep '^Gradle' || echo 'not found')"
    echo "Node:   $(node --version 2>/dev/null || echo 'not found')"
    echo "Python: $(python3 --version 2>/dev/null || echo 'not found')"
    echo ".NET:   $(dotnet --version 2>/dev/null || echo 'not found')"
}

# ------------------------------------------
# Utility Functions
# ------------------------------------------

# Quick jump to common directory
function work() {
    cd ~/work/talkdesk/code
}

# Quick process search
function findproc() {
    ps aux | grep -i "$1"
}

# Create directory and enter
function mkcd() {
    mkdir -p "$1" && cd "$1"
}
