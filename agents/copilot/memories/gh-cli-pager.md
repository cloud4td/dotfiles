# gh CLI — always disable pager

Running `gh` in the VS Code integrated terminal can crash VS Code when it
invokes a pager (less) for long output. Affects `gh pr view`, `gh run view`,
`gh pr list`, `gh issue view`, etc.

Rule: ALWAYS prefix `gh` commands with `GH_PAGER=cat` or pass `--no-pager`
when running via run_in_terminal / execution_subagent. Never run bare
pager-invoking `gh` subcommands.
