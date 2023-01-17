#!/bin/sh
set -e

echo "==> [INFO] use global ssh config for replace https to ssh for github.com"

git config --global --add url."git@github.com:".insteadOf "https://github.com/"

echo "==> Done."
