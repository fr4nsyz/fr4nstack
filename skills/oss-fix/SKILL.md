---
name: oss-fix
description: Work an open-source issue end to end - reproduce, write a test that fails before the fix, implement, adversarial review, then prove the behavior with real tools (debuggers, tracers, the actual binary). Use when the user links or pastes a GitHub issue, says "look into this issue", "fix this bug in <project>", or starts a feature in a repo they don't own.
argument-hint: "<issue url | description>"
---

Gates are in order. Don't start a step until the previous one has evidence.

1. **Read the room.** Issue thread, linked PRs, `CONTRIBUTING.md`, PR template, commit conventions (`git log --oneline -30`), DCO / `Signed-off-by` requirements, test and lint commands, supported versions. Check nobody else has an open PR for it. If the repo is unfamiliar, suggest `/repo-map` first.
2. **Reproduce.** Build from source and trigger the bug (or confirm the feature is missing) with the smallest input. Record the exact command, version/commit, and observed vs expected output. No repro -> stop and report what was tried; don't fix blind.
3. **Failing test.** Write the narrowest test in the repo's own test framework that fails for the reported reason. Run it and paste the failure. Follow `/tdd`'s rules for when a test is impractical.
4. **Fix.** Smallest change that makes the test pass and matches the codebase's style. No drive-by refactors.
5. **Adversarial review.** Run `/interrogate` on the diff. Act on consensus findings; note dismissed ones and why.
6. **Prove it with real tools.** Pick what gives certainty for this bug and run it; don't infer from reading code:
   - debugger on the real code path (`dlv`, `gdb`/`lldb`, `pdb`, `node --inspect`) with a breakpoint showing the fixed state
   - tracing (`strace`, `bpftrace`, `perf`, logs at debug level) for syscall, kernel or concurrency bugs
   - the built binary or service run against the original repro
   - race detector / sanitizers (`go test -race`, ASan/UBSan) where relevant
   Show before (on the base commit) and after. Run the full relevant test package, lint and typecheck.
7. **Hand off.** Branch and commit per the project's conventions (sign-off if required, using the git identity configured for this repo; ask if unset). Draft the PR description from the template: problem, root cause, fix, how it was verified (commands + results). Don't push or open the PR until the user says so.

Report at each gate in one or two lines: what was done, the evidence, pass/fail.
