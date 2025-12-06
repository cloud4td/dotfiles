# Custom Zsh Prompt Configuration
# This file provides a beautiful and informative prompt
# Shows: user@host, current directory, git branch, exit status, privileges

# Enable prompt substitution
setopt PROMPT_SUBST

# Load version control info
autoload -Uz vcs_info
precmd() { vcs_info }

# Git info format
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' %F{yellow}%b%f'
zstyle ':vcs_info:git:*' actionformats ' %F{yellow}%b%f %F{red}(%a)%f'

# Git status symbols
autoload -Uz add-zsh-hook
function update_git_status() {
    GIT_STATUS=""

    if git rev-parse --git-dir > /dev/null 2>&1; then
        # Check for uncommitted changes
        if ! git diff --quiet 2>/dev/null; then
            GIT_STATUS="${GIT_STATUS}%F{red}✗%f"
        fi

        # Check for staged changes
        if ! git diff --cached --quiet 2>/dev/null; then
            GIT_STATUS="${GIT_STATUS}%F{green}✓%f"
        fi

        # Check for untracked files
        if [ -n "$(git ls-files --others --exclude-standard 2>/dev/null)" ]; then
            GIT_STATUS="${GIT_STATUS}%F{magenta}+%f"
        fi

        # Check for stashed changes
        if git rev-parse --verify refs/stash >/dev/null 2>&1; then
            GIT_STATUS="${GIT_STATUS}%F{cyan}⚑%f"
        fi

        # Add space if we have status
        if [ -n "$GIT_STATUS" ]; then
            GIT_STATUS=" ${GIT_STATUS}"
        fi
    fi
}

add-zsh-hook precmd update_git_status

# Color definitions
USER_COLOR="%F{green}"
HOST_COLOR="%F{cyan}"
DIR_COLOR="%F{blue}"
PROMPT_SYMBOL_COLOR="%F{green}"
ERROR_SYMBOL_COLOR="%F{red}"
ROOT_COLOR="%F{red}"
RESET="%f"

# Username and hostname (different colors for root and SSH)
if [[ $EUID -eq 0 ]]; then
    # Root user - red
    USER_HOST="${ROOT_COLOR}%n@%m${RESET}"
    PROMPT_CHAR="${ROOT_COLOR}#${RESET}"
elif [[ -n $SSH_CONNECTION ]]; then
    # SSH connection - highlight
    USER_HOST="${USER_COLOR}%n${RESET}@${HOST_COLOR}%m${RESET}"
    PROMPT_CHAR="%(?:${PROMPT_SYMBOL_COLOR}:${ERROR_SYMBOL_COLOR})❯${RESET}"
else
    # Local user
    USER_HOST="${USER_COLOR}%n${RESET}"
    PROMPT_CHAR="%(?:${PROMPT_SYMBOL_COLOR}:${ERROR_SYMBOL_COLOR})❯${RESET}"
fi

# Directory with home replacement
CURRENT_DIR="${DIR_COLOR}%~${RESET}"

# Build the prompt
# Format: [user@host] directory (git-branch) ✗✓+
# ❯
PROMPT='${USER_HOST} ${CURRENT_DIR}${vcs_info_msg_0_}${GIT_STATUS}
${PROMPT_CHAR} '

# Right prompt (optional): time and exit code
RPROMPT='%(?..%F{red}✘ %?%f) %F{242}%*%f'
