#!/bin/sh
set -e

echo "==> [INFO] use ssh instead of https for github in current git repository"

git config --add url."git@github.com:".insteadOf "https://github.com/"

echo "==> Done."
echo "  run command 'git config --get url.\"git@github.com:\".insteadOf' to see configuration for current repository."
