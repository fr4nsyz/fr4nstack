---
name: stage
description: Build-deploy-test loop for staging - picks the next dev image tag, builds and pushes, points helmfile at a local chart and the new tag, diffs, syncs to staging, waits for rollout, checks the running image, tails logs, runs the test. Use for "deploy to staging", "test this in staging", "build an image", "helmfile sync", "do I need a new image".
argument-hint: "<service> [--tag X.Y.Z-dev.N] [--local-chart] [--no-build]"
---

Staging only. If any step resolves to a prod target, stop. Run `/env staging` first if auth hasn't been checked this session.

1. **Plan, then confirm once.** Read `infra.md`. Print what will happen:
   - service, repo + branch + commit to build
   - image: `<registry>/<image>:<tag>`; next tag = highest `-dev.N` in the registry + 1
   - deploy repo, helmfile file, `-e staging`, release label, target context
   - whether a local chart is needed (chart change on an unmerged helm-charts branch)
   - test to run afterward
   If code changed since the last image, a new image is needed. If only values/chart changed, it isn't. Say which and why.
2. **Build and push** (skip with `--no-build`). Use the build command in `infra.md` (platform, target, build args). Run in the background per `/longrun` if slow. If push needs auth or a secret the sandbox can't reach, give the user the exact command and wait.
3. **Point the deploy at it.**
   - Set the image tag in the staging values file.
   - `--local-chart`: create the `.helmfile-*-localchart.yaml` copy pointing at the local helm-charts checkout. Don't commit it.
   - Switch to the target context, since helmfile deploys to the current context.
4. **Diff.** `helmfile -e staging -f <file> -l name=<release> diff`. Show a short summary of what changes. Unexpected changes (other releases, secrets, RBAC) -> stop and ask.
5. **Sync.** `helmfile ... sync` (or `apply`). Then `kubectl rollout status deploy/<name> -n <ns> --timeout=5m`.
6. **Verify the running thing**, not the plan:
   - `kubectl get pods -n <ns> -o jsonpath='{..image}'` matches the new tag
   - pods Ready, restart count 0, no CrashLoopBackOff
   - tail logs for startup errors
7. **Test.** Run the agreed test (repo e2e, curl, or the repo's `verify-*` skill if present). Report pass/fail with output.
8. **Report:**

```
Staging: <service> <tag> on <context>  [PASS | FAIL]
Image running: <image@tag> (verified)
Test: <name> - <result>
Leftovers: <local chart file, values change to revert or commit>
```

Never leave a values-file tag change uncommitted without listing it under Leftovers.
