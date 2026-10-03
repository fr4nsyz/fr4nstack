# Third-party code

Everything below is vendored: copied into this repo at a pinned commit and reviewed, so upstream changes never reach my setup without a deliberate re-vendor. Each modified `SKILL.md` carries a notice comment pointing here.

Changes common to all vendored skills: removed `allowed-tools` (so normal permission prompts apply), removed install-it-yourself instructions in favor of "tell the user", and rewrote references to skills that aren't vendored.

| Component | Source | Commit | License | Changes |
|---|---|---|---|---|
| `skills/go-{error-handling,code-review,concurrency,context,interfaces,naming}` | [cxuu/golang-skills](https://github.com/cxuu/golang-skills) | `91f0c2eef559` | Apache-2.0; content derived from Google Go style guide (CC-BY 3.0), see `licenses/cxuu-golang-skills.THIRD_PARTY_NOTICES.md` | removed `allowed-tools` |
| `skills/golang-{troubleshooting,concurrency,safety,testing,benchmark}` | [samber/cc-skills-golang](https://github.com/samber/cc-skills-golang) | `8e899e20ff0c` | MIT | removed `allowed-tools` (one granted unrestricted `Bash` and `curl`) and `openclaw` install metadata; rewrote cross-skill references |
| `skills/use-modern-go` | [JetBrains/go-modern-guidelines](https://github.com/JetBrains/go-modern-guidelines) `plugin/skills/use-modern-go` | `155dc7ca10da` | Apache-2.0 | wrapper runs a locally built binary instead of `go install` on first use; removed Windows wrapper; match surrounding code in existing repos instead of always forcing modern idioms |
| `tools/go-modern-guidelines` | same repo, CLI source | `155dc7ca10da` | Apache-2.0 | removed plugin/agent config dirs and CI; built by `make tools` |
| `skills/debugging-code` | [AlmogBaku/debug-skill](https://github.com/AlmogBaku/debug-skill) `skills/debugging-code` | `26ef325fe218` | MIT | removed "install it NOW" section and `install-dap.sh` (curl download without checksum) |
| `tools/dap` | same repo, CLI source | `26ef325fe218` | MIT | **security:** `backend.go` binds `dlv dap` and js-debug to `127.0.0.1` (upstream listened on all interfaces, unauthenticated); removed CI and media; built by `make tools` |
| `skills/modern-cpp` | [trailofbits/skills](https://github.com/trailofbits/skills) `plugins/modern-cpp` | `82fe82262526` | CC-BY-SA-4.0 | respect the project's C++ standard; `-ftrivial-auto-var-init=zero` for release builds only |
| `skills/{address-sanitizer,libfuzzer,harness-writing}` | trailofbits/skills `plugins/testing-handbook-skills` | `82fe82262526` | CC-BY-SA-4.0 | corrected macOS ASan support; noted which related skills are installed |
| `plugins/c-review` | trailofbits/skills `plugins/c-review` | `82fe82262526` | CC-BY-SA-4.0 | removed `allowed-tools` (granted unrestricted `Bash`). Its scripts' PEP 723 deps (`tree-sitter==0.26.0`, `tree-sitter-c==0.24.2`, `tree-sitter-cpp==0.23.4`) are exact-pinned and fetched by `uv` on first run |
| `skills/{sanitizers,cmake,lldb,core-dumps}` | [mohitmishra786/low-level-dev-skills](https://github.com/mohitmishra786/low-level-dev-skills) | `bdc58472fa9f` | MIT | fixed nonexistent `-fsanitize=gwp-asan`, gcc examples using clang-only UBSan groups, a broken shell line continuation; rewrote cross-skill paths |
| `plugins/gopls-lsp` | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) `plugins/gopls-lsp` | `d182ca456ca0` | Apache-2.0 | LSP config moved into this repo's `.claude-plugin/marketplace.json`; gopls pinned in `Makefile` |
| `skills/{blast-radius,interrogate,recall,reflect,how,unslop,bro,tdd,show-me-your-work,create-verification-skill,typescript-best-practices,principle-*}` | [poteto's pstack](https://github.com/cursor/plugins/tree/main/pstack) via [backnotprop/pstack](https://github.com/backnotprop/pstack) | `157aae39a733` | MIT | see README credits |

Full license texts are in `licenses/`. Files under CC-BY-SA-4.0 stay under CC-BY-SA-4.0 including my modifications; everything else of mine is MIT (`LICENSE`).

## Re-vendoring

Clone upstream at a new commit, diff it against the vendored copy, review the diff (especially scripts and anything that installs or fetches), re-apply the changes above, update the commit column.
