# OpenClaw Config Change Checklist

When adding, renaming, or deleting an agent, **always update ALL of these locations**:

1. `agents/<agent-id>/config.json5` — agent config (id, workspace path, bindings, channel vars)
2. `agents/<agent-id>/workspace/*.md` — all workspace files (IDENTITY, SOUL, AGENTS, TOOLS, USER)
3. `.env` — environment variables (add/rename/remove channel ID vars)
4. `README.md` — Slack Channel IDs table, Environment Variables table, mention gating notes
5. `shared/config.json5` — if any global settings reference the agent

## Lesson Learned
- When renaming an agent (e.g. wfm-speckit-docs → wfm-idea-to-requirement), missed updating `.env`
- When deleting an agent (wfm-validate), missed removing its env var from `.env`
- When adding a new agent (help-product-wfm), missed adding its env var to `.env`
- **Always do a grep for the old agent name across the entire repo after any rename/delete to catch stragglers**
