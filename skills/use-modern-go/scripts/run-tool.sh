#!/usr/bin/env sh
# Runs the go-modern-guidelines CLI built from fr4nstack's vendored source (`make tools`). Never installs from the network.
set -eu
bin="${GO_MODERN_GUIDELINES_BIN:-$HOME/.local/bin/go-modern-guidelines}"
if [ ! -x "$bin" ]; then
	echo "go-modern-guidelines: $bin not found. Ask the user to run 'make tools' in their fr4nstack checkout." >&2
	exit 1
fi
exec "$bin" "$@"
