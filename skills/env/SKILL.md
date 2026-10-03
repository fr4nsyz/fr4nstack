---
name: env
description: Preflight before any Kubernetes/Helm/cloud work - confirms target cluster and whether it's staging or prod, checks auth for every CLI, and prints exact re-auth commands. Use at the start of infra work, when a cluster command fails with 401/403/expired token, or when the user asks "is this staging?", "which cluster", "do we need to reauth".
argument-hint: "[target env or context, e.g. staging | my-staging-cluster]"
---

1. **Load the map.** Find the nearest `infra.md` walking up from the cwd (e.g. at your work folder root). If none exists, build one from `kubectl config view` and ask the user to confirm which contexts are prod.
2. **Resolve the target.** From `$ARGUMENTS` or the task, pick the context(s). State them with their env from `infra.md`. If the current context differs from the target, say so; tools like helmfile deploy to the current context.
3. **Check auth, read-only and in parallel**, with short timeouts (`--request-timeout=10s`):
   - kube: `kubectl --context <ctx> auth can-i get pods -A`
   - oc (OpenShift contexts): `oc whoami --context <ctx>`
   - cloud CLI and registry login, using the check commands listed in `infra.md`
   - `gh auth status` if PRs are involved
4. **Output a banner**, verdict first:

```
Target: <context>  [STAGING | PROD (read-only)]
Mode:   read-only | write (staging only)
Auth:   kube ok | oc EXPIRED | cloud ok | registry ok | gh ok
```

5. For anything expired or failing, give the exact command for the user to run with `!`, using the fix column in `infra.md`. For OpenShift, name the correct console (staging vs prod server) so they don't fetch a token from the wrong cluster.
6. After the user says "authed", re-run only the failed checks and confirm.

Never write to a cluster in this skill. Never print tokens or secrets.
