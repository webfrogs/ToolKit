#!/bin/sh
set -e

if test ! -x "$(command -v go)"; then
	echo "[ERROR] Golang is not installed."
	exit
fi

current_version=$(go version | awk '{print $3}' | sed 's/go//')
target_version="1.21"
if [ "$(printf '%s\n' $target_version $current_version | sort -V | head -n1)" = "$target_version" ]; then
  echo "go version is higher than 1.20.x"
  exit 1
fi

go install golang.org/x/tools/gopls@v0.15.3

