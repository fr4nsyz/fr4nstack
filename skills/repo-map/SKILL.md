---
name: repo-map
description: Onboard onto an unfamiliar repo - map its components and every integration (external APIs, databases, queues, cloud, kernel, other services), render a mermaid diagram, and mark where a given bug or feature lives. Use when the user is new to a repo, says "map this repo", "how is this put together", "where does this bug live", or before /oss-fix in an unfamiliar codebase.
argument-hint: "[issue url | symbol | file to locate on the map]"
---

1. **Inventory.** Read README, docs, build files (`go.mod`, `package.json`, `Cargo.toml`, `pyproject.toml`, `Makefile`), deploy manifests, CI workflows. List the entry points (binaries, `main`s, CLIs, servers, operators, daemons).
2. **Components.** Group the code into 5-12 components by directory and responsibility. For large repos, spawn parallel Explore agents, one per top-level area, and merge their findings.
3. **Integrations.** For every component, find what it talks to and how: HTTP/gRPC clients and servers, DBs, caches, queues, k8s API, cloud SDKs, kernel interfaces (eBPF, netlink, syscalls), files, env/config. Cite the `file:line` where each connection is made.
4. **Locate the target.** If an issue, symbol or file was given, trace it to its component and the call path that reaches it from an entry point.
5. **Diagram.** One mermaid `flowchart`:
   - subgraphs for in-repo components, separate nodes for external systems
   - edges labeled with protocol or call (`gRPC`, `SQL`, `netlink`, `watch`)
   - the target highlighted: `classDef bug fill:#f66,stroke:#900,color:#fff` on the target node and its call path
   - keep it under ~40 nodes; add a second diagram for the target's call path if needed
6. **Write `<repo>-map.md`** in the directory containing the repo root (never inside the repo): the diagram(s), a table of component -> path -> one-line role, a table of integrations with `file:line`, and the target's call path. Offer to publish it as an artifact if the user wants to view it rendered.

Say what you couldn't trace instead of guessing an edge.
