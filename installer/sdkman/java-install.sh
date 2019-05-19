#!/bin/sh
set -e

if test ! -x "$(command -v sdk)"; then
    echo "[Error] sdkman is not installed."
    exit 1
fi

