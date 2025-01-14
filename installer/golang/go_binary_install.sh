#!/bin/sh
set -e

if test ! -x "$(command -v go)"; then
	echo "[ERROR] Golang is not installed."
	exit
fi

go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/cweill/gotests/gotests@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install mvdan.cc/gofumpt@latest
# go install golang.org/x/lint/golint
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install honnef.co/go/tools/cmd/staticcheck@latest
go install github.com/fatih/gomodifytags@latest
go install github.com/josharian/impl@latest
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest


