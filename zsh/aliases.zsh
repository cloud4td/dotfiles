# Aliases
# These aliases can be safely committed to git

# Privileges
alias asadmin="/Applications/Privileges.app/Contents/MacOS/PrivilegesCLI --add --reason need-to-ask-for-permission-to-install-apps-or-update-configs"
alias asuser="/Applications/Privileges.app/Contents/MacOS/PrivilegesCLI --remove"

# Podman as Docker replacement
# Docker compatibility enabled - use podman commands with docker CLI
alias docker=podman
alias docker-compose=podman-compose

# Podman-specific commands
alias pc=podman-compose
alias pps='podman ps'
alias pimg='podman images'

# VPN Proxy Settings
alias vpn_on="export https_proxy=http://127.0.0.1:6152;export http_proxy=http://127.0.0.1:6152;export all_proxy=socks5://127.0.0.1:6153"
