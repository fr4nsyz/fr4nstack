# fr4nstack

my Claude Code skills, written after reading every prompt i'd sent Claude for a month and noticing i kept asking for the same things.

## what's in here

### workflow

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

### review, learning, writing

`/blast-radius`, `/interrogate`, `/recall`, `/reflect`, `/how`, `/unslop`, `/bro`, `/tdd`, `/show-me-your-work`, `/create-verification-skill`, `typescript-best-practices` (auto-loads on `.ts`/`.tsx`), plus two `principle-*` skills it reads. these are manual-only (`/name`).

### go

| skill | what it covers |
|---|---|
| `go-error-handling`, `go-code-review`, `go-concurrency`, `go-context`, `go-interfaces`, `go-naming` | Google/Uber/Effective Go style rules, review checklist by severity, AST checkers |
| `golang-troubleshooting`, `golang-concurrency`, `golang-safety`, `golang-testing`, `golang-benchmark` | symptom-to-tool debugging, race/leak checks, typed-nil and aliasing traps, `synctest`, pprof + benchstat |
| `use-modern-go` | idioms gated on the Go version in `go.mod` |
| `debugging-code` | live `dlv`/`lldb-dap` sessions Claude drives across commands |
| `gopls-lsp` (plugin) | gopls symbol/reference lookup |

### c++

| skill | what it covers |
|---|---|
| `modern-cpp` | legacy-to-modern C++ table, hardening flags |
| `sanitizers`, `cmake`, `lldb`, `core-dumps` | which sanitizer for which bug, modern CMake, LLDB, core triage |
| `address-sanitizer`, `libfuzzer`, `harness-writing` | fuzzing with libFuzzer + ASan, harness design |
| `c-review` (plugin) | multi-agent C/C++ security audit (heavy: 4-14 agents) |

### the rest

- `CLAUDE.md`: how i want Claude to answer (verdict first, measured vs estimated, no em dashes) and a coaching section that makes Claude suggest the next skill to run, with a reason. it's how i'm training myself to actually use these.
- `hooks/prod-guard.sh`: PreToolUse hook that blocks `kubectl`/`oc`/`helm`/`helmfile` writes against anything named prod, and asks when it can't tell. extra prod patterns go in `~/.claude/hooks/prod-guard.patterns` (see the `.example`). it reads the command line only, so a script that runs `kubectl apply` inside it won't be caught.
- `infra.example.md`: template for the cluster/deploy/auth map the infra skills read. keep the real one out of git.
- `settings.example.json`: the hook wiring.

## install

```bash
git clone https://github.com/fr4nsyz/fr4nstack.git
cd fr4nstack
make install        # skills + prod guard into ~/.claude
make tools          # dap + go-modern-guidelines, built from the vendored source
make gopls dlv      # pinned versions
```

plugins install from this checkout, not from upstream:

```
/plugin marketplace add /path/to/fr4nstack
/plugin install gopls-lsp@fr4nstack
/plugin install c-review@fr4nstack
```

then merge `settings.example.json` into `~/.claude/settings.json`, take whatever you want from `CLAUDE.md`, and write your own `infra.md` from the example if you do cluster work. the guard needs `jq`; `c-review` needs `uv`; C/C++ debugging needs `lldb-dap` from Homebrew `llvm`.

workflow skills can also trigger on their own when your wording matches.

## credits

the skills under "review, learning, writing" come from [poteto's pstack](https://github.com/cursor/plugins/tree/main/pstack) (MIT) via the [backnotprop/pstack](https://github.com/backnotprop/pstack) mirror. changes: removed references to pstack skills not included here, pointed them at `gh`/`git` and the workflow skills instead, and made `typescript-best-practices` load automatically.

the go and c++ skills come from [cxuu/golang-skills](https://github.com/cxuu/golang-skills), [samber/cc-skills-golang](https://github.com/samber/cc-skills-golang), [JetBrains/go-modern-guidelines](https://github.com/JetBrains/go-modern-guidelines), [AlmogBaku/debug-skill](https://github.com/AlmogBaku/debug-skill), [trailofbits/skills](https://github.com/trailofbits/skills), [mohitmishra786/low-level-dev-skills](https://github.com/mohitmishra786/low-level-dev-skills) and [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official).

all third-party code is vendored at pinned commits and reviewed, not pulled from upstream at install time. [`THIRD_PARTY.md`](THIRD_PARTY.md) lists every source, commit, license and change (including a security fix to the debugger's network binding). license texts are in [`licenses/`](licenses/); the Trail of Bits skills stay CC-BY-SA-4.0.
