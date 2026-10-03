---
name: deps-fix
description: Remediate dependency vulnerabilities (CVE reports from Mend, Dependabot, npm audit, pip-audit, etc.) with minimal breakage, then produce a targeted manual test list. Use when the user pastes a vuln report or asks to fix CVEs or bump vulnerable packages.
argument-hint: "[vuln list or report]"
---

1. **Inventory.** Table: package, current, fixed version, direct or transitive (and parent), major bump yes/no. Detect package manager and runtime version requirements (engines, `.nvmrc`, `python_requires`).
2. **Fix in order of least risk.** After each step, re-run the local scanner (`npm audit`, `yarn audit`, `pip-audit`, `bundle audit`) to confirm the finding cleared. If the authoritative scanner only runs in CI (e.g. Mend on a PR), say so and open the PR early so it can report.
   1. Regenerate the lockfile within existing ranges.
   2. Loosen over-tight pins to major (`^3`), not patch.
   3. Bump the parent of a transitive dependency.
   4. Last resort: `overrides` / `resolutions` / constraints. Note each one; they need more testing.
   Unfixable (no patched release, abandoned): list with reason, don't force.
3. **Verify.** Install clean, build, typecheck, run tests. Show lockfile diff size; explain if it's large.
4. **Risk call.** For each major bump, read the changelog for breaking changes and grep the codebase for affected APIs. Verdict per package: low / medium / high risk.
5. **Manual test list.** Map each bumped package to the user-facing features that use it (grep imports). Output what to click through, e.g. "socket.io-client bump -> test live chat connect/reconnect".
6. Hand off to `/ship` if the user wants a PR.
