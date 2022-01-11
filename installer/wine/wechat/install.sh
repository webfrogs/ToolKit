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

yay -S deepin-wine5 deepin-wine-helper --noconfirm

# install deepin wechat
#yay -S deepin-wine-wechat --noconfirm
cd /tmp
rm -rf deepin-wine-wechat-arch
git clone https://github.com/vufa/deepin-wine-wechat-arch.git
cd deepin-wine-wechat-arch
makepkg -si
cd ..
rm -rf deepin-wine-wechat-arch

# add wechat to PATH
sudo ln -sf /opt/apps/com.qq.weixin.deepin/files/run.sh /usr/local/bin/wechat

