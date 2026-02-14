---
name: devtools
description: Custom development workflow automation tools for GitHub Actions, PR management, and code documentation generation. Use when the user asks about or wants to: (1) Run GitHub workflows, (2) Approve GitHub Action environment gates, (3) Auto-approve PRs, (4) Create PRs with signed commits, (5) Generate code documentation or knowledge base prompts from codebases, (6) Work with repository documentation, (7) Trigger CI/CD pipelines. Triggers on keywords like "github workflow", "approve PR", "sign commits", "generate docs", "code documentation", "knowledge base", or mentions of specific command names (gh-run-approve, auto-approve-pr-workflow, sign-commit-pr, generate-kb-prompts).
---

# Development Workflow Tools

Custom shell commands for automating GitHub workflows, PR approvals, commit signing, and code documentation generation.

## Available Commands

### gh-run-approve

Generic GitHub Action runner with optional auto-approval of environment gates. The most flexible command for triggering and managing GitHub workflows.

**Usage:**

```bash
# Run workflow with auto-approval
gh-run-approve --repo owner/repo --workflow deploy.yaml --environment production

# With workflow inputs
gh-run-approve --repo Talkdesk/wem-common-workflows \
  --workflow auto-approve-pr.yaml \
  --input pr_url=https://github.com/Talkdesk/pm-monorepo/pull/49 \
  --environment pr-review

# Multiple inputs with custom branch
gh-run-approve --repo myorg/myrepo \
  --workflow deploy.yaml \
  --branch develop \
  --input env=staging \
  --input version=1.2.3 \
  --environment staging

# Run without auto-approval (just monitor)
gh-run-approve --repo myorg/myrepo --workflow build.yaml --input tag=v1.0.0

# Custom wait timeout
gh-run-approve --repo myorg/myrepo \
  --workflow deploy.yaml \
  --environment production \
  --wait-timeout 300
```

**Options:**

- `--repo <REPO>` - Repository in format owner/repo (required)
- `--workflow <WORKFLOW>` - Workflow file name (required)
- `--input <KEY=VALUE>` - Workflow input, can be specified multiple times
- `--environment <ENV>` - Environment name to auto-approve
- `--branch <BRANCH>` - Branch to run workflow on (default: repo's default branch)
- `--wait-timeout <SEC>` - Maximum seconds to wait for approval gate (default: 120)

**How it works:**

1. Triggers the specified GitHub workflow with provided inputs
2. Monitors the workflow execution status
3. If environment specified, waits for approval gate to appear
4. Automatically approves the specified environment
5. Watches workflow progress until completion

**Requirements:** GitHub CLI (`gh`) must be installed and authenticated with appropriate permissions.

### auto-approve-pr-workflow

Convenience wrapper for the Talkdesk PR approval workflow. Specifically designed for Talkdesk's `wem-common-workflows` repository.

**Usage:**

```bash
auto-approve-pr-workflow https://github.com/Talkdesk/pm-monorepo/pull/49
```

**What it does:** Triggers the `auto-approve-pr.yaml` workflow in `wem-common-workflows` and auto-approves the `pr-review` environment.

**Note:** This is a legacy wrapper. For more flexibility, use `gh-run-approve` directly:

```bash
gh-run-approve --repo Talkdesk/wem-common-workflows \
  --workflow auto-approve-pr.yaml \
  --input pr_url=<PR_URL> \
  --environment pr-review
```

**Requirements:**

- GitHub CLI (`gh`) authenticated
- Access to `Talkdesk/wem-common-workflows` repository
- Appropriate permissions to approve workflow deployments

### sign-commit-pr

Create a new PR with signed commits from an existing PR. Useful for ensuring all commits in a PR are properly signed according to repository requirements.

**Usage:**

```bash
sign-commit-pr https://github.com/Talkdesk/pm-monorepo/pull/49
```

**What it does:** Triggers the `sign-commit-pr.yaml` workflow in `wem-common-workflows` to create a new PR with signed commits from the original PR.

**Equivalent command:**

```bash
gh-run-approve --repo Talkdesk/wem-common-workflows \
  --workflow sign-commit-pr.yaml \
  --input pr_url=<PR_URL> \
  --wait-timeout 60
```

**Requirements:**

- GitHub CLI (`gh`) authenticated
- Access to `Talkdesk/wem-common-workflows` repository

### generate-kb-prompts

Generate comprehensive code documentation for workspaces or repositories using `code2prompt`. Creates LLM-ready documentation in XML or Markdown format with token counting.

**Usage:**

```bash
# Generate all documentation (root + all repos)
generate-kb-prompts

# Generate only root documentation
generate-kb-prompts root

# Generate specific repository documentation
generate-kb-prompts wfm-core

# Use Markdown format instead of XML
generate-kb-prompts -f markdown

# Include only specific file patterns
generate-kb-prompts -i '*.md,*.txt' root

# Custom token encoding for different LLMs
generate-kb-prompts -e p50k root

# Quiet mode (suppress progress messages)
generate-kb-prompts -q wfm-core

# Custom output directory
generate-kb-prompts -o custom-prompts
```

**Options:**

- `-f, --format <FORMAT>` - Output format: `xml` (default) or `markdown`
- `-e, --encoding <ENCODING>` - Token encoding: `cl100k` (GPT-4, default), `p50k` (Codex), `p50k_edit`, `r50k` (GPT-3)
- `-i, --include <PATTERNS>` - Include only specific file patterns (e.g., `*.md,*.txt`)
- `-o, --output <DIR>` - Output directory (default: `prompts`)
- `-q, --quiet` - Suppress progress messages
- `-h, --help` - Show help message

**Target:**

- (empty) - Generate all documentation (root + all repos)
- `root` - Generate only root documentation
- `<repo-name>` - Generate only specific repo documentation

**How it works:**

1. Scans the specified target (root, specific repo, or all)
2. Excludes common build artifacts and dependencies (node_modules, dist, etc.)
3. Applies optional file pattern filtering
4. Generates documentation with token counting using specified encoding
5. Outputs to `prompts/` directory (or custom directory)

**Output files:**

- `prompt-root.txt` - Root workspace documentation
- `prompt-<repo-name>.txt` - Individual repository documentation

**Common exclusions:** node_modules, dist, build, target, .git, .vscode, venv, **pycache**, package-lock files, media files (png, jpg, etc.), test data/fixtures, and more.

**Requirements:**

- `code2prompt` CLI tool must be installed
- Expected directory structure: `repos/` subdirectory for repositories

## Workflow Patterns

### PR Approval Workflow

When a user wants to approve a PR through automation:

1. Determine if it's Talkdesk-specific (`auto-approve-pr-workflow`) or generic (`gh-run-approve`)
2. Get the PR URL
3. Run the appropriate command
4. Monitor the workflow execution

### Custom Workflow Execution

When a user wants to run a custom GitHub workflow:

1. Identify the repository and workflow file
2. Gather required inputs
3. Determine if environment approval is needed
4. Use `gh-run-approve` with appropriate parameters
5. Handle timeout if approval gate doesn't appear

### Documentation Generation

When a user wants to generate code documentation:

1. Determine scope (root, specific repo, or all)
2. Choose format based on intended LLM (cl100k for GPT-4, p50k for Codex)
3. Apply file filters if needed (e.g., only markdown files)
4. Run `generate-kb-prompts` with appropriate options
5. Output files will be in `prompts/` directory

## Tips

**For gh-run-approve:**

- Always specify both `--repo` and `--workflow`
- Use `--environment` only when you need auto-approval
- Multiple `--input` flags can be used for multiple parameters
- Default timeout is 120s; increase with `--wait-timeout` if needed
- Workflow will be watched automatically after approval

**For generate-kb-prompts:**

- Use `cl100k` encoding for GPT-4/GPT-3.5-turbo (most accurate)
- Use `markdown` format for better readability in some contexts
- Filter with `-i '*.md'` when only documentation is needed
- Run with `-q` in scripts to suppress progress output
- Generated files include token counts for context management

**General:**

- All commands require GitHub CLI (`gh`) to be properly authenticated
- Commands are available globally when `bin/` is in PATH
- Check command output for workflow URLs and debugging information
- Environment approval is automatic when specified, but watch for errors
