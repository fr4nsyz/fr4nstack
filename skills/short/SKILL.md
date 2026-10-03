---
name: short
description: Write short text in the user's voice - tickets with acceptance criteria, messages to a mentor/lead/teammate, weekly updates, commit or PR summaries. Use when the user asks to draft a message, make tickets, fill out an update, or "sum it up".
argument-hint: "<ticket | msg | weekly | summary> [context]"
---

Voice: casual, direct, lowercase is fine for chat messages. Plain words. No em dashes, no curly quotes, no "I hope this finds you well", no "delve", "robust", "seamless", "leverage". Never sound like an AI wrote it. Apply the rules in `~/.claude/skills/unslop/SKILL.md` to the draft.

Length defaults (go shorter if possible):
- **msg**: 2-3 sentences. One question max, stated concretely (name the column, PR, or file).
- **summary**: 1-2 sentences.
- **weekly**: 3-5 bullets per section, one line each.
- **ticket**:

```
Title: <verb + object>

<1-2 sentence why>

Scope
- <item>

Acceptance tests
- <observable, testable check>

Links: <branch / PR URLs>
```

Write to a file if the user asks or if there are multiple tickets. Show the draft, don't explain it. If facts are missing, leave `<placeholder>` and list them in one line after.
