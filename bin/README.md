# Custom Commands (bin/)

This directory contains standalone executable scripts that can be run directly from the command line.

## Available Commands

### `auto-approve-pr-workflow`
Automatically trigger and approve a GitHub workflow for PR approval in the Talkdesk ecosystem.

**What it does:**
1. Triggers the `auto-approve-pr.yaml` workflow in `wem-common-workflows`
2. Waits for the workflow to reach the `manual-gate` (pr-review environment)
3. Automatically approves the pending deployment
4. Provides real-time status updates and helpful links

**Usage:**
```bash
# Approve a specific PR via workflow
auto-approve-pr-workflow https://github.com/Talkdesk/pm-monorepo/pull/49

# Or with any other Talkdesk repository PR
auto-approve-pr-workflow https://github.com/Talkdesk/wfm-monorepo/pull/215
```

**Requirements:**
- GitHub CLI (`gh`) must be installed and authenticated
- Access to `Talkdesk/wem-common-workflows` repository
- Appropriate permissions to approve workflow deployments

**Example output:**
```
🚀 Triggering auto-approve workflow for: https://github.com/Talkdesk/pm-monorepo/pull/49
✅ Workflow triggered!
⏳ Waiting for run to start...
📋 Run ID: 19985801938
⏳ Waiting for manual-gate...
✓ Workflow reached manual-gate
✍️  Approving workflow...
   Found pr-review environment: 5035813277
✅ Approved pr-review environment!
🔗 Watch: gh run watch 19985801938 --repo Talkdesk/wem-common-workflows
```

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
