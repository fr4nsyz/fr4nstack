# Builds vendored tools from source in this repo. Go module downloads are verified against go.sum.
BIN ?= $(HOME)/.local/bin
GOPLS_VERSION ?= v0.21.1
DLV_VERSION ?= v1.27.2
export GOFLAGS = -mod=readonly
export GOTOOLCHAIN = local

.PHONY: tools gopls dlv install test-tools

tools:
	mkdir -p $(BIN)
	cd tools/dap && CGO_ENABLED=0 go build -trimpath -o $(BIN)/dap ./cmd/dap
	cd tools/go-modern-guidelines && CGO_ENABLED=0 go build -trimpath -o $(BIN)/go-modern-guidelines .

gopls:
	GOBIN=$(BIN) go install golang.org/x/tools/gopls@$(GOPLS_VERSION)

test-tools:
	cd tools/dap && go test -run 'Test[^E]' ./...
	cd tools/go-modern-guidelines && go test ./...

install:
	mkdir -p $(HOME)/.claude/skills $(HOME)/.claude/hooks
	cp -R skills/* $(HOME)/.claude/skills/
	cp hooks/prod-guard.sh $(HOME)/.claude/hooks/ && chmod +x $(HOME)/.claude/hooks/prod-guard.sh

dlv:
	GOBIN=$(BIN) go install github.com/go-delve/delve/cmd/dlv@$(DLV_VERSION)
