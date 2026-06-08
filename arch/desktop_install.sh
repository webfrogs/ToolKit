#!/bin/bash
set -e
set -o pipefail

cd $(dirname $0)

sudo pacman -Syy

echo "==> Installing necessary packages..."
sudo pacman -S --noconfirm \
  sddm firefox thunderbird \
  kde-cli-tools okular gwenview xdg-user-dirs \
  thunar tumbler ffmpegthumbnailer poppler-glib gvfs-smb file-roller thunar-archive-plugin gvfs-mtp libmtp \
  cups ark pavucontrol

sudo systemctl enable --now cups # printer

# create default user directories within $HOME directory
xdg-user-dirs-update

# install chinese input method
echo "==> Installing fcitx5..."
sudo pacman -S --noconfirm fcitx5-im fcitx5-chinese-addons fcitx5-rime
./bin/aur_install.sh rime-ice-git || true
mkdir -p $HOME/.local/share/fcitx5/rime/
cat <<'EOF' | tee $HOME/.local/share/fcitx5/rime/default.custom.yaml
patch:
  "menu/page_size": 10
  # 这里的 rime_ice_suggestion 为雾凇方案的默认预设
  __include: rime_ice_suggestion:/
EOF


# develop
sudo pacman -S --noconfirm protobuf

# desktop apps
echo "==> Installing desktop apps..."
sudo pacman -S --noconfirm telegram-desktop 
./bin/aur_install.sh 1password
sudo pacman -S --noconfirm remmina freerdp libvncserver  # remote desktop app
./bin/aur_install.sh wechat-bin
./bin/aur_install.sh wemeet-bin
./bin/aur_install.sh linuxqq
./bin/aur_install.sh feishu-bin
sudo pacman -S --noconfirm wireshark-qt
# media player
sudo pacman -S --noconfirm vlc vlc-plugins-all
# virtualbox
sudo pacman -S --noconfirm virtualbox virtualbox-host-modules-lts virtualbox-guest-iso
sudo gpasswd -a $USER vboxusers

./apps/chrome.sh || true

# fonts
echo "==> Installing fonts..."
sudo pacman -S --noconfirm noto-fonts-emoji # fix emoji
sudo pacman -S --noconfirm adobe-source-han-sans-cn-fonts
../installer/fonts/install.sh


echo "==> Configuring terminal..."
../configs/tty/config.sh

echo "==> Installing window manager..."
../installer/hyprland/install.sh

# start sddm
echo "==> Enabling sddm..."
sudo systemctl enable --now sddm
