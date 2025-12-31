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
sudo pacman -S --noconfirm adobe-source-han-sans-cn-fonts

# develop
sudo pacman -S --noconfirm protobuf

# media player
sudo pacman -S --noconfirm vlc vlc-plugins-all

sudo systemctl enable --now cups # printer

echo "==> install i3wm packages."
../i3/install.sh

../fonts/install.sh

./apps/tty.sh
./apps/1password.sh
./apps/pavucontrol.sh
./apps/chrome.sh || true

# start sddm
sudo systemctl enable --now sddm
