---
name: longrun
description: Protocol for long-running jobs (benchmarks, data pulls, training, builds, deploys, e2e runs). Estimates cost upfront, runs in background, monitors, retries, notifies. Use for any command expected to take more than ~2 minutes.
argument-hint: "<what to run>"
---

1. **Estimate before starting.** State expected duration, data size, and compute/money cost, plus how you estimated it. If it's over 30 min or touches shared resources (GPU in use, prod, rate-limited APIs), propose a smaller pilot (subset, fewer days, one model) and ask.
2. **Check for conflicts.** Is anything else using the resource (e.g. a training job on the GPU, another pull running)? Never interrupt an existing job.
3. **Run in background** with output to a log file in the scratchpad. Make it resumable: checkpoint progress so a failure doesn't restart from zero.
4. **Monitor** with the Monitor tool / background notifications, not repeated sleeps. On transient failure (timeout, 5xx, auth expiry) retry with backoff; on auth expiry tell the user exactly what to run.
5. **Notify** with a push notification when done or when blocked on the user.
6. **Report results** as a table. Tag every number `measured` or `estimated`. Include sample size, config, and anything that differed from the plan.

If the user asks for progress mid-run: percent done, elapsed, ETA, and any errors so far, in one or two lines.
