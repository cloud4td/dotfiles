# AI Agent Mode Configuration
# Activated when AGENT_MODE=1 is set in the environment
# Provides a minimal, non-blocking shell for AI coding agents (Copilot, Cline, Aider, etc.)

# 1. Disable colors, control characters, and fancy themes
export TERM=dumb
export DISABLE_AUTO_TITLE="true"
export ZSH_THEME=""  # Prevent Oh My Zsh from loading a theme

# 2. Minimal prompt for easy regex parsing by AI agents
export PS1="$ "
export PROMPT="$ "
unset RPROMPT

# 3. Disable pagers (prevent blocking on long output)
export PAGER=cat
export GIT_PAGER=cat

# 4. Safety: remove interactive aliases (rm -i, cp -i, mv -i) but do NOT force -f
unalias rm 2>/dev/null
unalias cp 2>/dev/null
unalias mv 2>/dev/null

# 5. Disable Oh My Zsh auto-update prompts (prevent blocking)
export DISABLE_AUTO_UPDATE="true"
export DISABLE_UPDATE_PROMPT="true"

# 6. Disable history expansion to prevent errors with '!' in commands
setopt NO_BANG_HIST
