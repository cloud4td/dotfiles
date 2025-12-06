# Custom Commands (bin/)

This directory contains standalone executable scripts that can be run directly from the command line.

## Available Commands

### `gh-run-approve`
Generic GitHub Action runner with optional auto-approval of environment gates.

**What it does:**
1. Triggers any GitHub workflow with custom inputs
2. Monitors the workflow execution status
3. Automatically approves specified environment gates when needed
4. Provides real-time status updates and helpful links

**Usage:**
```bash
# Basic usage - run workflow with auto-approval
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
gh-run-approve --repo myorg/myrepo \
  --workflow build.yaml \
  --input tag=v1.0.0

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
- `--branch <BRANCH>` - Branch to run workflow on
- `--wait-timeout <SEC>` - Maximum seconds to wait for approval gate (default: 120)

**Requirements:**
- GitHub CLI (`gh`) must be installed and authenticated
- Appropriate permissions to run workflows and approve deployments

### `auto-approve-pr-workflow`
Legacy wrapper for the Talkdesk PR approval workflow (now uses `gh-run-approve` internally).

**What it does:**
Triggers the `auto-approve-pr.yaml` workflow in `wem-common-workflows` and auto-approves the pr-review environment.

**Usage:**
```bash
# Approve a specific PR via workflow
auto-approve-pr-workflow https://github.com/Talkdesk/pm-monorepo/pull/49
```

**Note:** This is a convenience wrapper. For more flexibility, use `gh-run-approve` directly:
```bash
gh-run-approve --repo Talkdesk/wem-common-workflows \
  --workflow auto-approve-pr.yaml \
  --input pr_url=https://github.com/Talkdesk/pm-monorepo/pull/49 \
  --environment pr-review
```

**Requirements:**
- GitHub CLI (`gh`) must be installed and authenticated
- Access to `Talkdesk/wem-common-workflows` repository
- Appropriate permissions to approve workflow deployments

## Adding New Commands

1. Create a new file in `bin/` (without extension)
2. Add shebang at the top: `#!/usr/bin/env bash`
3. Make it executable: `chmod +x bin/your-command`
4. Use it directly: `your-command`

**Example:**
```bash
#!/usr/bin/env bash
# Description of your command

echo "Hello from custom command!"
```

The `bin/` directory is automatically added to your PATH via `zsh/env.zsh`.
