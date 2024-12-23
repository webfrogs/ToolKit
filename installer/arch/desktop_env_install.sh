#!/bin/bash
set -e
set -o pipefail

cd $(dirname $0)

sudo pacman -Syy

echo "==> install necessary packages."
sudo pacman -S --noconfirm \
  sddm dolphin firefox thunderbird \
  kde-cli-tools

# install chinese input method
sudo pacman -S --noconfirm fcitx-im fcitx-configtool fcitx-sunpinyin

sudo systemctl enable --now sddm

# fix i3wm dmenu input issue
if test ! -e "/etc/environment"; then
  sudo touch /etc/environment
fi
if test "$(grep -c '^GTK_IM_MODULE=fcitx' /etc/environment)" = "0"; then
	echo "GTK_IM_MODULE=fcitx" | sudo tee -a /etc/environment > /dev/null
fi
if test "$(grep -c '^QT_IM_MODULE=fcitx' /etc/environment)" = "0"; then
	echo "QT_IM_MODULE=fcitx" | sudo tee -a /etc/environment > /dev/null
fi
if test "$(grep -c '^XMODIFIERS=@im=fcitx' /etc/environment)" = "0"; then
	echo "XMODIFIERS=@im=fcitx" | sudo tee -a /etc/environment > /dev/null
fi

echo "==> install i3wm packages."
../i3/install.sh



