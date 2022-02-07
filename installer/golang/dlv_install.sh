#!/bin/sh
set -e

if test ! -x "$(command -v go)"; then
	echo "[ERROR] Golang is not installed."
	exit
fi

go install github.com/go-delve/delve/cmd/dlv@latest

