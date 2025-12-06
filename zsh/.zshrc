# Oh My Zsh configuration
# This file is loaded only for interactive shells
# Suitable for Oh My Zsh, aliases, prompts, plugins, etc.

export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Case-sensitive completion
# CASE_SENSITIVE="true"

# Hyphen-insensitive completion (case-sensitive completion must be off)
# HYPHEN_INSENSITIVE="true"

# Disable bi-weekly auto-update checks
# zstyle ':omz:update' mode disabled

# Auto-update without prompting
# zstyle ':omz:update' mode auto

# Update frequency (in days)
# zstyle ':omz:update' frequency 13

# Disable auto-setting terminal title
# DISABLE_AUTO_TITLE="true"

# Enable command auto-correction
# ENABLE_CORRECTION="true"

# Display red dots while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Disable marking untracked files under VCS as dirty (speeds up large repos)
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# History timestamp format
# HIST_STAMPS="mm/dd/yyyy"

# Plugins
plugins=(
  git                 # Git aliases and functions
  docker              # Docker aliases and completions
  docker-compose      # Docker Compose aliases
  kubectl             # Kubernetes aliases and completions
  # aws               # AWS CLI completions
  # terraform         # Terraform aliases and completions
  # node              # Node.js aliases
  # npm               # NPM completions
  zsh-autosuggestions # Fish-like autosuggestions (install: git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions)
  zsh-syntax-highlighting # Syntax highlighting (install: git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting)
)

source $ZSH/oh-my-zsh.sh

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY           # Append to history file
setopt SHARE_HISTORY            # Share history between sessions
setopt HIST_IGNORE_DUPS         # Ignore duplicate commands
setopt HIST_IGNORE_ALL_DUPS     # Remove older duplicates
setopt HIST_IGNORE_SPACE        # Ignore commands starting with space
setopt HIST_REDUCE_BLANKS       # Remove superfluous blanks
setopt HIST_VERIFY              # Show command before executing from history

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

# Key bindings
bindkey '^[[A' history-search-backward  # Up arrow
bindkey '^[[B' history-search-forward   # Down arrow
bindkey '^[[H' beginning-of-line        # Home
bindkey '^[[F' end-of-line              # End
bindkey '^[[3~' delete-char             # Delete

# Load custom configurations
DOTFILES_DIR="$HOME/dotfiles"

# Load aliases
[ -f "$DOTFILES_DIR/zsh/aliases.zsh" ] && source "$DOTFILES_DIR/zsh/aliases.zsh"

# Load custom functions and commands
[ -f "$DOTFILES_DIR/zsh/functions.zsh" ] && source "$DOTFILES_DIR/zsh/functions.zsh"

# Load Warp specific settings
[ -f "$DOTFILES_DIR/zsh/warp.zsh" ] && source "$DOTFILES_DIR/zsh/warp.zsh"

# Editor
export EDITOR=code
export VISUAL=code

# GPG (interactive shell specific)
export GPG_TTY=$(tty)

# Color support for ls and grep
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Aliases for colored output
alias ls='ls -G'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
