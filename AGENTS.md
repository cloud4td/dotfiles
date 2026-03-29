# Dotfiles — Project Instructions

## Overview

This is a personal dotfiles repository for macOS, devcontainer, and GitHub Codespaces. It manages shell configuration (zsh), VS Code settings, AI agent configurations, and custom CLI tools.

## Project Structure

- `zsh/` — Zsh shell configuration files (aliases, env, functions, prompt, secrets)
- `vscode/` — VS Code settings, keybindings, extensions, and snippets
- `agents/` — AI agent configuration (Claude Code settings, Copilot memories, MCP config)
- `bin/` — Standalone executable CLI tools (added to PATH)
- `scripts/` — Installation and setup scripts (bash)

## Conventions

- **Shell**: All scripts must be compatible with zsh on macOS. Use `#!/usr/bin/env bash` for bash scripts and `#!/bin/zsh` for zsh scripts.
- **Podman over Docker**: This machine uses podman instead of docker. Never generate docker commands; use podman equivalents.
- **Secrets**: Never commit tokens, credentials, or sensitive data. All secrets go in `zsh/secrets.zsh` (gitignored). Use `zsh/secrets.zsh.example` as a template.
- **Symlinks**: Configuration is applied via symlinks from `scripts/install.sh`. New config files should follow this pattern.
- **Bin scripts**: CLI tools in `bin/` should be self-contained, executable, include usage help when called without arguments, and follow the existing naming convention (kebab-case).

## File Editing Rules

- Do not modify `zsh/secrets.zsh` or create files containing real tokens/credentials.
- When adding new zsh configuration, place it in the appropriate file:
  - Environment variables → `zsh/env.zsh`
  - Aliases → `zsh/aliases.zsh`
  - Functions → `zsh/functions.zsh`
- When adding new CLI tools, place them in `bin/` and make them executable.
- When adding new setup steps, create a dedicated `scripts/setup-*.sh` script and call it from `scripts/install.sh`.

## Testing

- No automated test suite. Validate scripts by running them with `bash -n <script>` for syntax checking.
- Shell scripts should use `set -e` for strict error handling.
