# OpenClaw Agent Permission Model

## Roles

- **Cloud (admin)**: Full access to everything. Can query all members' data, modify configs, issue commands.
- **Team members (regular)**: Limited access. Can query their own data and submit their own information.

## Permission Rules

### Admin (Cloud)
- Query any member's data (features, estimations, workload, etc.)
- Modify agent configs, shared config, skills, cron jobs
- Issue write commands (Jira updates, DB writes, agent management)
- View all reports and analytics
- Grant/revoke member permissions

### Team Members
- Query their own assigned features, estimations, status
- Submit/update their own estimations and information
- Ask general project questions (release dates, sprint info, etc.)
- **Cannot** query other specific members' private data (e.g., individual accuracy, personal estimations)
- **Cannot** perform write operations beyond their own data
- **Cannot** access admin-only agents (e.g., openclaw-ops)

### Channel Behavior
- In Slack channels: members can ask questions about their own work
- Members may or may not be able to ask about others' work (context-dependent)
- Cloud can ask about anyone and everything
- Sensitive data (individual performance, accuracy metrics) is admin-only

## Implementation
- OpenClaw does NOT support per-agent config-level access control
- Permission enforcement is done via prompt-level instructions in each agent's SOUL.md / AGENTS.md
- Global `ALLOWED_USER_ID` in `.env` restricts the entire instance (all agents)
- For admin-only agents (openclaw-ops): hard gate in SOUL.md + AGENTS.md checking Slack user ID
- For shared agents: role-based logic — identify speaker via Slack ID → check `members` table → enforce permissions

## Security Reminders
- Never expose API keys, tokens, or secrets in responses
- Never broadcast individual members' estimation accuracy or private metrics
- Always verify speaker identity before processing sensitive requests
- Admin-only operations require explicit identity confirmation
