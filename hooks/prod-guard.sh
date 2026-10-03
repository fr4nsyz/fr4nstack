#!/usr/bin/env bash
# PreToolUse(Bash) guard: block cluster writes against prod; ask when the target can't be determined.
# Prod = any context/env/cluster name with a "prod"/"production" segment, plus extra EREs
# (one per line) in ~/.claude/hooks/prod-guard.patterns, e.g. a prod API server host.
set -uo pipefail

cmd=$(jq -r '.tool_input.command // empty')
[ -z "$cmd" ] && exit 0

decide() {
  jq -n --arg d "$1" --arg r "$2" \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:$d,permissionDecisionReason:$r}}'
  exit 0
}

write_re='\b(kubectl|oc)\b.*\b(apply|create|delete|patch|edit|replace|scale|annotate|label|taint|cordon|uncordon|drain|autoscale|expose|set|rollout[[:space:]]+(restart|undo|pause|resume))\b|\bhelm\b.*\b(install|upgrade|uninstall|rollback)\b|\bhelmfile\b.*\b(sync|apply|destroy|delete)\b'
exec_re='\b(kubectl|oc)\b.*\bexec\b'
prod_re='(^|[^a-z0-9])prod(uction)?([^a-z0-9]|$)'
extra="$HOME/.claude/hooks/prod-guard.patterns"
if [ -f "$extra" ]; then
  while IFS= read -r p; do
    [ -n "$p" ] && [ "${p#\#}" = "$p" ] && prod_re="$prod_re|$p"
  done < "$extra"
fi
ctx_re='--(kube-)?context|(^|[[:space:]])-e[[:space:]]|--environment|--cluster'

# Split on pipes, ;, &&, || and newlines so `kubectl get ... | grep delete` isn't a write.
while IFS= read -r seg; do
  if printf '%s' "$seg" | grep -qE -- "$write_re"; then kind=write
  elif printf '%s' "$seg" | grep -qE -- "$exec_re"; then kind=exec
  else continue; fi

  if printf '%s' "$seg" | grep -qiE -- "$prod_re"; then
    [ "$kind" = write ] && decide deny "Prod write blocked by prod-guard. Give the user the exact command to run themselves with \`!\`."
    decide ask "kubectl exec against prod."
  fi

  if printf '%s' "$seg" | grep -qE -- "$ctx_re"; then
    # Explicit target that isn't prod is fine; a shell variable can't be resolved here.
    if printf '%s' "$seg" | grep -qE -- "(--(kube-)?context|--cluster)[= ]+\"?\\$"; then
      decide ask "Cluster $kind with a context from a shell variable; can't verify it isn't prod."
    fi
    continue
  fi

  current=$(kubectl config current-context 2>/dev/null || true)
  if printf '%s' "$current" | grep -qiE -- "$prod_re"; then
    [ "$kind" = write ] && decide deny "Prod write blocked by prod-guard: no --context given and current context is $current."
    decide ask "kubectl exec with current context $current (prod)."
  fi
done < <(printf '%s\n' "$cmd" | sed -E 's/(\|\||&&|;|\|)/\n/g')

exit 0
