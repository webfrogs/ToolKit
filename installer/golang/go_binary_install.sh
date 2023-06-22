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
# go install golang.org/x/lint/golint

