#!/bin/sh
set -e

if test "$(uname -s)" != "Linux"; then
	echo "[ERROR] Not linux OS."
	exit 2
fi

if test ! -x "$(command -v pacman)"; then
  echo "[ERROR] pacman command is not found."
  exit 2
fi

if test ! -x "$(command -v yay)"; then
  echo "[ERROR] yay command is not found."
  exit 2
fi

# yay -S deepin-wine5 --noconfirm
yay -S deepin-wine-qq

sudo ln -sf /opt/apps/com.qq.im.deepin/files/run.sh /usr/local/bin/qq

/opt/apps/com.qq.im.deepin/files/run.sh -d
