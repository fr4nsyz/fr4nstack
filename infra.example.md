# Infra map

Read by `/env`, `/stage`, `/prod-look`. Put it at the root of your work folder as `infra.md`. Never commit secrets here.

## Kube contexts

| Context | Env | Cluster / role | API server |
|---|---|---|---|
| `my-staging/abc123` | staging | app cluster | `<host>:<port>` |
| `my-prod/def456` | **prod** | app cluster | `<host>:<port>` |
| `rancher-desktop` | local | local dev | localhost |

## Deploy repos

- **deploy-repo** (`helmfiles/`): `helmfile.yaml`. Envs: `-e staging`, `-e production`.
  - Does the helmfile pin `kubeContext`? If not, it deploys to the **current** context. Note any sanity-check hook.
  - Typical: `helmfile -e staging -l name=<release> diff`, then `sync`.
- **helm-charts**: chart sources; version bumps merge here first.

## Images

- Registry: `<registry>/<namespace>/<image>`
- Tags: `X.Y.Z` releases, `X.Y.Z-dev.N` for staging test builds.
- Build: `docker build --platform linux/amd64 -t <registry>/<image>:<tag> .`
- Push: `<registry login command>`, then `docker push`.

## Auth

| Tool | Check | Fix (user runs with `!`) |
|---|---|---|
| kube | `kubectl --context <ctx> auth can-i get pods` | `<cloud cli> cluster config ...` |
| cloud CLI | `<cloud cli> whoami/target` | `<cloud cli> login --sso` |
| registry | `<registry list command>` | `<registry login command>` |
| gh | `gh auth status` | `gh auth login` |

## Rules

- Prod is read-only for Claude (enforced by `hooks/prod-guard.sh`).
