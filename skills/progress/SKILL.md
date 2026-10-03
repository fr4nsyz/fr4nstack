---
name: progress
description: Reconcile project progress against ticket/spec files (jira*.md, plan.md, order.md, etc.) and update a STATUS.md. Use when the user asks "status", "where are we", "which tickets are done", or "what's next".
argument-hint: "[spec file or glob, default: jira*.md plan*.md order.md]"
---

1. Find the spec files: `$ARGUMENTS` if given, else `jira*.md`, `plan*.md`, `order.md`, `TICKETS*.md` in the cwd. If none exist, ask which file defines the work.
2. Read `STATUS.md` if it exists.
3. For every ticket or acceptance criterion in the spec, check the actual state:
   - code on which branch, committed or not, pushed or not
   - PR open/merged (`gh pr list --author @me`, `gh pr view`)
   - tests passing (run them if cheap)
   Do not trust STATUS.md or memory over the repo; verify.
4. Output, verdict first:

```
Overall: <one line>

Done:        <ticket> - <evidence: PR URL / commit>
In progress: <ticket> - <what's left>
Blocked:     <ticket> - <blocker, who unblocks it>
Next:        <single recommended next ticket and why>
```

5. If `STATUS.md` already exists or the user asks for a file, write the same content there with today's date, under 40 lines. Put it next to the spec files, never inside a git repo unless it's already tracked there.

Rules: full URLs for PRs. Mark anything you couldn't verify as `(unverified)`.
