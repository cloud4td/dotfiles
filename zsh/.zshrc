# Zsh Interactive Shell Configuration
# This file is loaded only for interactive shells
# Powered by zinit + Powerlevel10k

# ==========================================
# Terminal Environment Isolation: AI Agent vs Human Developer
# ==========================================
# When AGENT_MODE=1 is set, enter minimal mode for AI agents
# Otherwise, load the full interactive developer environment

if [[ "$AGENT_MODE" == "1" ]]; then

    # AI Agent mode: minimal, non-blocking shell
    DOTFILES_DIR="$HOME/dotfiles"
    [ -f "$DOTFILES_DIR/zsh/agent.zsh" ] && source "$DOTFILES_DIR/zsh/agent.zsh"

    # Load only essential aliases (docker, etc.) without color aliases
    [ -f "$DOTFILES_DIR/zsh/aliases.zsh" ] && source "$DOTFILES_DIR/zsh/aliases.zsh"

    # Agent-specific: override color aliases set by aliases.zsh
    unalias ls 2>/dev/null
    unalias ll 2>/dev/null
    unalias la 2>/dev/null
    unalias grep 2>/dev/null
    unalias fgrep 2>/dev/null
    unalias egrep 2>/dev/null

    # Added by Antigravity
    export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

    # OpenClaw Completion
    [[ -f "$HOME/.openclaw/completions/openclaw.zsh" ]] && source "$HOME/.openclaw/completions/openclaw.zsh"

    return 0
fi

# ==========================================
# Human Developer Mode (full interactive environment)
# Powered by zinit + Powerlevel10k
# ==========================================

# ------------------------------------------
# Powerlevel10k Instant Prompt (must be near top)
# ------------------------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ------------------------------------------
# zinit Plugin Manager
# ------------------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -f "$ZINIT_HOME/zinit.zsh" ]]; then
    print -P "%F{33}▓▒░ Installing zinit…%f"
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# ------------------------------------------
# Powerlevel10k Theme (async, zero-latency)
# ------------------------------------------
zinit ice depth=1
zinit light romkatv/powerlevel10k
# Load p10k config (run `p10k configure` to regenerate)
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh || [[ -f "$HOME/dotfiles/zsh/p10k.zsh" ]] && source "$HOME/dotfiles/zsh/p10k.zsh"

# ------------------------------------------
# Essential Plugins (三大神器)
# ------------------------------------------
# 1. zsh-autosuggestions: Fish-like history suggestions (→ to accept)
zinit light zsh-users/zsh-autosuggestions
# 2. zsh-completions: Enhanced Tab completions
zinit light zsh-users/zsh-completions
# 3. zsh-syntax-highlighting: Real-time syntax coloring
zinit light zsh-users/zsh-syntax-highlighting
# 4. zsh-history-substring-search: ↑↓ searches history by substring (load after syntax-highlighting)
zinit light zsh-users/zsh-history-substring-search

# ------------------------------------------
# OMZ Snippets (cherry-picked, no full OMZ framework)
# ------------------------------------------
zinit snippet OMZP::git              # Git aliases and functions
zinit snippet OMZP::docker           # Docker completions
zinit snippet OMZP::docker-compose   # Docker Compose completions
zinit snippet OMZP::kubectl          # Kubernetes aliases and completions
zinit snippet OMZP::colored-man-pages # Colorize man pages
zinit snippet OMZP::command-not-found # Suggest package for missing commands
zinit snippet OMZP::extract          # Universal archive extractor
zinit snippet OMZP::sudo             # Press ESC twice to add sudo
zinit snippet OMZP::web-search       # Search from terminal (google, github, etc.)
zinit snippet OMZP::copypath         # Copy current path to clipboard
zinit snippet OMZP::copyfile         # Copy file content to clipboard
zinit snippet OMZP::dirhistory       # Navigate directory history (Alt+Left/Right)

# ------------------------------------------
# Completion System
# ------------------------------------------
autoload -Uz compinit
# Only regenerate .zcompdump once a day for speed
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi
zinit cdreplay -q  # Replay cached completions

# ------------------------------------------
# History
# ------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt APPEND_HISTORY           # Append to history file
setopt SHARE_HISTORY            # Share history between sessions
setopt HIST_IGNORE_DUPS         # Ignore duplicate commands
setopt HIST_IGNORE_ALL_DUPS     # Remove older duplicates
setopt HIST_IGNORE_SPACE        # Ignore commands starting with space
setopt HIST_REDUCE_BLANKS       # Remove superfluous blanks
setopt HIST_VERIFY              # Show command before executing from history
setopt INC_APPEND_HISTORY       # Write to history immediately
setopt HIST_FIND_NO_DUPS        # Skip duplicates in history search

# ------------------------------------------
# Shell Options
# ------------------------------------------
# Directory navigation
setopt AUTO_CD                  # Type directory name to cd
setopt AUTO_PUSHD               # Make cd push old directory onto stack
setopt PUSHD_IGNORE_DUPS        # Don't push duplicates
setopt PUSHD_SILENT             # Don't print directory stack

# Completion
setopt COMPLETE_IN_WORD         # Complete from both ends of word
setopt ALWAYS_TO_END            # Move cursor to end on complete
setopt AUTO_MENU                # Show completion menu on tab
setopt AUTO_LIST                # List choices on ambiguous completion
setopt MENU_COMPLETE            # Insert first match immediately

# ------------------------------------------
# Key Bindings
# ------------------------------------------
bindkey '^[[A' history-substring-search-up    # Up arrow: substring history search
bindkey '^[[B' history-substring-search-down  # Down arrow: substring history search
bindkey '^[[H' beginning-of-line        # Home
bindkey '^[[F' end-of-line              # End
bindkey '^[[3~' delete-char             # Delete

# ------------------------------------------
# Load Dotfiles Configs
# ------------------------------------------
DOTFILES_DIR="$HOME/dotfiles"

# Prompt is now handled by Powerlevel10k (prompt.zsh no longer needed)

# Load aliases
[ -f "$DOTFILES_DIR/zsh/aliases.zsh" ] && source "$DOTFILES_DIR/zsh/aliases.zsh"

# Load custom functions and commands
[ -f "$DOTFILES_DIR/zsh/functions.zsh" ] && source "$DOTFILES_DIR/zsh/functions.zsh"

# Load Warp specific settings
[ -f "$DOTFILES_DIR/zsh/warp.zsh" ] && source "$DOTFILES_DIR/zsh/warp.zsh"

# ------------------------------------------
# Environment (interactive-only)
# ------------------------------------------
export EDITOR=code
export VISUAL=code

# GPG (interactive shell specific)
export GPG_TTY=$(tty)

# Color support for ls and grep
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export LS_COLORS='di=1;36:ln=1;35:so=1;32:pi=1;33:ex=1;31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=34;43'

# Aliases for colored output
alias ls='ls -G'
alias ll='ls -lhG'
alias la='ls -lahG'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Better directory listing with eza/exa if available
if command -v eza &> /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -l --icons --group-directories-first --git'
    alias la='eza -la --icons --group-directories-first --git'
    alias lt='eza -T --icons --group-directories-first'
    alias tree='eza -T --icons'
elif command -v exa &> /dev/null; then
    alias ls='exa --icons --group-directories-first'
    alias ll='exa -l --icons --group-directories-first --git'
    alias la='exa -la --icons --group-directories-first --git'
    alias lt='exa -T --icons --group-directories-first'
    alias tree='exa -T --icons'
fi

# Git aliases (supplements OMZP::git)
alias gst='git status'
alias gss='git status -s'
alias glog='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gds='git diff --staged'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias gba='git branch -a'

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# OpenClaw Completion
[[ -f "$HOME/.openclaw/completions/openclaw.zsh" ]] && source "$HOME/.openclaw/completions/openclaw.zsh"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
