#!/bin/bash
set -e
set -o pipefail

cd $(dirname $0)

sudo pacman -Syy

echo "==> install necessary packages."
sudo pacman -S --noconfirm \
  sddm dolphin firefox thunderbird \
  kde-cli-tools okular gwenview \
  cups ark pavucontrol

# install chinese input method
# sudo pacman -S --noconfirm fcitx-im fcitx-configtool fcitx-sunpinyin
sudo pacman -S --noconfirm fcitx5-im fcitx5-chinese-addons

# fix emoji
sudo pacman -S --noconfirm noto-fonts-emoji

./apps/tty.sh

# develop
sudo pacman -S --noconfirm protobuf

sudo systemctl enable --now cups # printer

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
if test "$(grep -c '^SDL_IM_MODULE=fcitx' /etc/environment)" = "0"; then
	echo "SDL_IM_MODULE=fcitx" | sudo tee -a /etc/environment > /dev/null
fi
if test "$(grep -c '^GLFW_IM_MODULE=ibus' /etc/environment)" = "0"; then
	echo "GLFW_IM_MODULE=ibus" | sudo tee -a /etc/environment > /dev/null
fi

echo "==> install i3wm packages."
../i3/install.sh

../fonts/install.sh

# start sddm
sudo systemctl enable --now sddm
