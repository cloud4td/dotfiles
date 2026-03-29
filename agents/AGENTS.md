# User-Level Agent Instructions

## Language

- Respond in the same language the user uses. Default to English if ambiguous.

## Code Style

- Be concise. Avoid over-engineering.
- Only make changes that are directly requested or clearly necessary.
- Don't add docstrings, comments, or type annotations to code you didn't change.
- Don't add error handling for scenarios that can't happen.
- Don't create helpers or abstractions for one-time operations.

## Workflow

- Always use the `skill-creator` skill when creating or updating skills.
- When asked to "add skills", create them in the `.agents/skills/` directory of the current repository.
- Read files before modifying them. Understand existing code before suggesting changes.
- For multi-step tasks, use a todo list to track progress.

## Project Instructions Convention

To support both Copilot and Claude Code from a single source, every project should use `AGENTS.md` at the repo root as the single source of truth for project-level instructions.

- **Copilot**: In `.github/copilot-instructions.md`, include the root `AGENTS.md`:
  ```markdown
  @AGENTS.md
  ```
- **Claude Code**: In `CLAUDE.md`, include the root `AGENTS.md`:
  ```markdown
  @AGENTS.md
  ```
- Do NOT duplicate instructions across `copilot-instructions.md` and `CLAUDE.md`. Keep all shared rules in `AGENTS.md` and only put platform-specific overrides in the respective files.

## Conventions

- Use podman instead of docker on this machine.
- macOS is the primary OS; scripts should be compatible with zsh.
