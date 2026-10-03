# fr4nstack

my Claude Code skills. half borrowed from [poteto's pstack](https://github.com/cursor/plugins/tree/main/pstack), half written after reading every prompt i'd sent Claude for a month and noticing i kept asking for the same things.

## what's in here

### mine

| skill | what it does |
|---|---|
| `/progress` | checks every ticket in your spec files against real branches, PRs and tests. verdict first, one recommended next ticket |
| `/ship` | trims comments in the diff, runs what CI runs, conventional branch, one-line commit, PR, full URLs |
| `/audit` | read-only review. findings with `file:line`, tagged verified or unverified |
| `/longrun` | for anything over ~2 min: estimate first, run in background, retry, notify when done. numbers tagged measured or estimated |
| `/short` | tickets, messages, weekly updates. short, no AI voice |
| `/deps-fix` | CVE fixes in order of least risk, then a list of what to test by hand |
| `/teach` | explains what was built, then quizzes you on it |
| `/env` | infra preflight: which cluster, staging or prod, is auth still valid, exact re-auth command |
| `/stage` | build, push, helmfile diff, sync to staging, confirm the new image is actually running, test |
| `/prod-look` | read-only investigation across prod clusters, summarized per cluster |
| `/repo-map` | new to a repo: components, every integration with `file:line`, a mermaid diagram with the bug's location highlighted |
| `/oss-fix` | open-source issue flow: reproduce, failing test, fix, adversarial review, then prove it with a debugger/tracer/the real binary |

### from pstack (MIT, modified)

`/blast-radius`, `/interrogate`, `/recall`, `/reflect`, `/how`, `/unslop`, `/bro`, `/tdd`, `/show-me-your-work`, `/create-verification-skill`, `typescript-best-practices` (auto-loads on `.ts`/`.tsx`), plus two `principle-*` skills it reads.

changes from upstream: removed references to pstack skills i don't use (`why`, `arena`, `session-pickup`, `maintain-verification-skill`, some principles), pointed them at `gh`/`git` and my own skills instead, and made `typescript-best-practices` load automatically. pstack's license is in [`LICENSE-pstack`](LICENSE-pstack).

### the rest

- `CLAUDE.md`: how i want Claude to answer (verdict first, measured vs estimated, no em dashes) and a coaching section that makes Claude suggest the next skill to run, with a reason. it's how i'm training myself to actually use these.
- `hooks/prod-guard.sh`: PreToolUse hook that blocks `kubectl`/`oc`/`helm`/`helmfile` writes against anything named prod, and asks when it can't tell. extra prod patterns go in `~/.claude/hooks/prod-guard.patterns` (see the `.example`). it reads the command line only, so a script that runs `kubectl apply` inside it won't be caught.
- `infra.example.md`: template for the cluster/deploy/auth map the infra skills read. keep the real one out of git.
- `settings.example.json`: the hook wiring.

## install

```bash
git clone https://github.com/fr4nsyz/fr4nstack.git
cd fr4nstack
mkdir -p ~/.claude/skills ~/.claude/hooks
cp -R skills/* ~/.claude/skills/
cp hooks/prod-guard.sh ~/.claude/hooks/ && chmod +x ~/.claude/hooks/prod-guard.sh
```

then merge `settings.example.json` into `~/.claude/settings.json`, take whatever you want from `CLAUDE.md`, and write your own `infra.md` from the example if you do cluster work. the guard needs `jq`.

pstack skills are manual-only (`/name`). mine can also trigger on their own when your wording matches.
