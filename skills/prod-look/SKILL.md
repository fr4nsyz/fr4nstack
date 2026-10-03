---
name: prod-look
description: Read-only investigation across production clusters - logs, events, pod status, resource usage, deployed versions - summarized per cluster. Use for "check prod", "look at the prod logs", "is X happening in prod", "what's running on the node", "how many users", incident or abuse investigation.
argument-hint: "<question> [service | namespace | clusters]"
---

**Read-only. Allowed:** `get`, `describe`, `logs`, `top`, `events`, `auth can-i`, `config view`, `helm list/get/history`, `helmfile diff`. **Not allowed:** any write, `exec`, `port-forward`, `cp`, or outbound requests to prod services. If answering needs one of these, stop, explain why, and give the user the command to run.

1. **Scope.** From `infra.md`, list the prod contexts relevant to the question (e.g. every prod cluster the service runs on). Check auth on each (as in `/env`); skip and report any that fail rather than blocking on them.
2. **Query in parallel** across clusters with `--request-timeout=30s`. Keep raw output in scratchpad files, not in chat. For logs, use `--since` and `--previous` deliberately; say which window you covered. Note log retention limits when the answer needs older data.
3. **Summarize per cluster:**

```
<context> (<role>)
  <finding, with count/rate and time window>
  evidence: <scratchpad file or command>
```

4. **Answer the question first**, then the per-cluster table. Tag each number as measured (from output) or estimated. Name any cluster or window you couldn't see.
5. If the investigation surfaces something worth acting on, propose the fix and where it'd be tested (staging via `/stage`), but don't apply it.

Treat usernames and user data as sensitive: don't include them in files meant for sharing unless asked.
