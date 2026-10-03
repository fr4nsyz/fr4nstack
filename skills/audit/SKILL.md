---
name: audit
description: Read-only review of a branch, PR, or fix. Never edits code. Writes findings with file:line and verified/unverified tags. Use when the user asks to review a PR, review a diff, check if a fix is proper, or confirm something works.
argument-hint: "[PR url | branch | base..head] [requirements text or file]"
---

**Read-only. Do not edit, commit, or push anything.** If a fix seems obvious, describe it in the finding.

1. Get the diff: PR via `gh pr diff`, else `git diff <base>...<head>` (default base: main).
2. If requirements were given (ticket text, spec), list each one and check it against the diff.
3. Review for, in priority order: correctness, fault tolerance (failure paths, retries, timeouts, partial failure), security, regressions, unnecessary complexity (is this more than the problem needs?), tests covering the change.
4. Verify claims before reporting. Run tests, read the called code, check library behavior in docs or source. A finding you couldn't confirm is tagged `UNVERIFIED` with what would confirm it.
5. Write `REVIEW.md` in the directory containing the repo root, never inside the repo:

```
Verdict: <ready | ready with nits | not ready> - <one line why>

## Requirements
- [x|~|  ] <requirement> - <where / gap>

## Findings
1. [high|med|low] [VERIFIED|UNVERIFIED] path/to/file.ts:42
   <problem in one or two sentences>
   Fix: <one line>
```

6. In chat: verdict line + count of findings by severity + file path. No full dump.

For "what could this break" questions, use `/blast-radius`. For multi-model adversarial review, use `/interrogate`.

Skip style nits unless asked. Rank by severity.
