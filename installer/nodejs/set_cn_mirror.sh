#!/bin/bash
set -e

echo "[INFO] Start to set cn mirrors for yarn and npm"

if test -x "$(command -v yarn)"; then
  yarn config set registry https://registry.npm.taobao.org/
  echo "[INFO] yarn cn mirror is set."
else
	echo "[WARNING] Command 'yarn' is not found."
fi

if test -x "$(command -v npm)"; then
  npm config set registry https://registry.npm.taobao.org/
  echo "[INFO] npm cn mirror is set."
else
	echo "[WARNING] Command 'npm' is not found."
fi

