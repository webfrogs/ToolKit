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

yay -S deepin-wine5 --noconfirm
yay -S deepin-wine-wechat --noconfirm

sudo ln -sf /opt/apps/com.qq.weixin.deepin/files/run.sh /usr/local/bin/wechat
# change wechat wine to deepin-wine
/opt/apps/com.qq.weixin.deepin/files/run.sh -d

