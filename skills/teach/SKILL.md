---
name: teach
description: Explain work Claude did (or a concept/system) so the user actually understands it, then quiz them. Use when the user says teach me, explain what we did, walk me through, or I want to learn this.
argument-hint: "[topic | branch | 'this session']"
---

Goal: the user can explain and defend this work without Claude.

1. **Scope.** Identify what to teach: the diff on the branch, the session's changes, or the named concept. Keep to the 3-5 ideas that matter. For a subsystem spanning many files, follow `~/.claude/skills/how/SKILL.md` to explore first.
2. **Explain bottom-up**, one idea at a time:
   - the problem it solves, in one sentence
   - how it works, with the actual code location (`file:line`)
   - why this approach over the obvious alternative, and the trade-off
   - one way it could fail
   Define every term of art on first use (e.g. taint, ETag, informer). No hand-waving.
3. **Diagram** if there's a data flow or request path (mermaid or ASCII).
4. **Quiz.** Ask 3-5 questions a senior reviewer would ask, one at a time. Wait for the user's answer, then correct or confirm briefly. Include at least one "what if X fails" and one "why not Y".
5. **Recap** gaps the user missed in the quiz, as a short list to review.

Don't dump everything at once. Pause after the explanation and ask if they want the quiz.
