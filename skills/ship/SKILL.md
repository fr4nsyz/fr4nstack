---
name: ship
description: Prepare current changes for review - trim comments, run format/lint/tests, branch, commit, open PR, print full URLs. Use when the user says ship, cut the PR, make a PR, or get this ready for review.
argument-hint: "[ticket id] [--no-pr] [--no-commit]"
---

Steps, stop and report on any failure:

1. **Scope check.** `git status` and `git diff` against the base branch. List files changed. Flag anything unrelated (lockfile churn, eslint config, test scripts, scratch files) and ask before including it.
2. **Comment cleanup.** In the diff only, remove comments that restate code, narrate changes ("now uses X"), or are banners. Keep comments that explain a non-obvious why. Don't touch pre-existing comments outside the diff.
3. **Checks.** Detect and run what CI runs: formatter (check mode, then fix), linter, typecheck, unit tests. Read `.github/workflows` to match CI exactly. Report pass/fail with output for failures.
4. **Branch.** If on the default branch, create one using conventional prefixes: `feat/`, `fix/`, `chore/`, `refactor/`, `test/`, `docs/`. Short kebab-case. Follow CONTRIBUTING.md if present.
5. **Commit** (skip if `--no-commit`). One line, imperative, under 72 chars. No body unless asked. Follow repo conventions from `git log --oneline -20`.
6. **PR** (skip if `--no-pr`). Invoking `/ship` is the go-ahead to push and open the PR; ask only if the base branch or stacking is unclear. Body: empty, or `Jira: <ticket id>` if a ticket id was given or CI requires it. No "Generated with Claude Code" line and no Co-Authored-By trailer. Stack on another branch if the change depends on it.
7. **Output** full `https://` URLs for every PR and branch touched.

Never force-push or amend a pushed commit without asking.
