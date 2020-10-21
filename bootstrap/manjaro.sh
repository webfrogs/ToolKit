#!/bin/sh
set -e

cd $(dirname $0)
cd ..
RootPath=$(pwd)

if test "$(uname -s)" != "Linux"; then
  echo "[ERROR] Current OS is not Linux"
  exit 2
fi

if test ! -x "$(command -v pacman)"; then
  echo "[ERROR] pacman command is not found."
  exit 2
fi

sudo pacman -Syy
sudo pacman-mirrors -i -c China -m rank
if grep -Fxq "[archlinuxcn]" /etc/pacman.conf; then
	echo "[INFO] archlinux cn already exists in file '/etc/pacman.conf'"
else
	echo "[archlinuxcn]" | sudo tee -a /etc/pacman.conf
	echo "SigLevel = Optional TrustedOnly" | sudo tee -a /etc/pacman.conf
	echo 'Server = http://mirrors.tuna.tsinghua.edu.cn/archlinuxcn//$arch' | sudo tee -a /etc/pacman.conf
	sudo pacman -Syy
	sudo pacman -S archlinuxcn-keyring
fi
sudo pacman -S \
  git vim zip unzip \
  terminator base-devel \
  resolvconf net-tools \
  blueman network-manager-applet

# install chinese input method
sudo pacman -S fcitx-im fcitx-configtool fcitx-sunpinyin
cat <<EOF > ~/.pam_environment
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
EOF

sudo pacman -S flameshot

./configs/git/git-configer.sh
./configs/zsh/config.sh

./installer/docker/install.sh
./installer/nodejs/install.sh
./installer/neovim/install.sh

# install yay
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -si
cd ${RootPath}

#yay -S deepin-wine
#yay -S deepin-wine-wechat



