# dotfiles

Personal configuration files (dotfiles) for setting up development environments across different machines.

## Contents

This repository contains configuration files for:

- **Bash** (`.bashrc`, `.bash_profile`) - Shell configuration with aliases, prompt customization, and environment settings
- **Git** (`.gitconfig`, `.gitignore_global`) - Git configuration with useful aliases and global ignore rules
- **Vim** (`.vimrc`) - Text editor configuration with sensible defaults

## Installation

### Quick Install

Clone the repository and run the installation script:

```bash
git clone https://github.com/cloud4td/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The installation script will:
1. Create backups of any existing dotfiles (with `.backup` extension)
2. Create symlinks from your home directory to the dotfiles in this repository
3. Preserve your ability to update dotfiles via git

### Manual Installation

If you prefer to install manually, you can create symlinks yourself:

```bash
ln -sf ~/dotfiles/.bashrc ~/.bashrc
ln -sf ~/dotfiles/.bash_profile ~/.bash_profile
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.gitignore_global ~/.gitignore_global
ln -sf ~/dotfiles/.vimrc ~/.vimrc
```

## Post-Installation

After installation:

1. **Update Git configuration** - Edit `.gitconfig` and update your name and email:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

2. **Reload shell configuration**:
   ```bash
   source ~/.bashrc
   ```

## Customization

Feel free to fork this repository and customize the dotfiles to your preferences. Some common customizations:

- Add more aliases to `.bashrc`
- Customize the shell prompt in `.bashrc`
- Add Vim plugins and customize color schemes in `.vimrc`
- Add more Git aliases in `.gitconfig`

## Features

### Bash
- Colored prompt with username, hostname, and current directory
- History configuration for better command history
- Useful aliases for common commands (ls, git, navigation)
- Bash completion support

### Git
- Colorized output for better readability
- Useful aliases (st, co, br, ci, lg, etc.)
- Global gitignore for common files to exclude
- Sensible defaults for push, pull, and merge

### Vim
- Line numbers and syntax highlighting
- Smart indentation and search
- Useful key mappings with leader key
- No backup or swap files
- Status line with file information

## Updating

To update your dotfiles with the latest changes:

```bash
cd ~/dotfiles
git pull origin main
```

Since the files are symlinked, changes will be reflected immediately.

## License

Feel free to use and modify these dotfiles as you see fit.

## Contributing

This is a personal dotfiles repository, but suggestions and improvements are welcome via issues or pull requests.