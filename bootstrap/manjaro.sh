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

# check proxys
# echo "==> checking proxy"
# read -p "Should use proxy? [y/n]: " use_proxy
# if test "${use_proxy}" = "y"; then
#   echo "Default http proxy address is 127.0.0.1:1089"
#   read -p "Input http proxy addres, press enter to use default: " proxy_addr
#   if test -z "${proxy_addr}"; then
#     proxy_addr="127.0.0.1:1089"
#   fi
#   export http_proxy="http://${proxy_addr}"
#   export https_proxy="http://${proxy_addr}"
#   echo "http proxy is set to 'http://${proxy_addr}'"
# else
#   echo "No proxy is set."
# fi

echo "==> start to bootstrap manjaro."

read -p "Want to use pacman cn mirror? [y/n]: " use_pacman_cn_mirror
if test "${use_pacman_cn_mirror}" = "y"; then
  ./installer/manjaro/pacman_cn_mirror.sh
fi

echo "==> add archlinuxcn pacman source."
if grep -Fxq "[archlinuxcn]" /etc/pacman.conf; then
	echo "[INFO] archlinux cn already exists in file '/etc/pacman.conf'"
else
	echo "[archlinuxcn]" | sudo tee -a /etc/pacman.conf
	echo "SigLevel = Optional TrustedOnly" | sudo tee -a /etc/pacman.conf
	echo 'Server = http://mirrors.tuna.tsinghua.edu.cn/archlinuxcn//$arch' | sudo tee -a /etc/pacman.conf
	sudo pacman -Syy
	sudo pacman -S archlinuxcn-keyring --noconfirm

  # fix archlinuxcn key can not import
  # see https://www.archlinuxcn.org/gnupg-2-1-and-the-pacman-keyring/
  sudo pacman -S --noconfirm haveged
  sudo systemctl enable --now haveged
  sudo rm -rf /etc/pacman.d/gnupg
  sudo pacman-key --init
  # sudo pacman-key --populate archlinux
  # sudo pacman-key --populate archlinuxcn
  sudo pacman-key --populate
fi

# install necessary packages
echo "==> install necessary packages."
sudo pacman -S --noconfirm \
  base-devel \
  git vim zip tree unzip \
  terminator hexchat \
  resolvconf net-tools \
  dnsutils iputils socat \
  blueman network-manager-applet

# TODO: unzip-iconv is not installed

# install chinese input method
sudo pacman -S fcitx-im fcitx-configtool fcitx-sunpinyin --noconfirm

mkdir ~/.config/environment.d
cat <<EOF > ~/.config/environment.d/fcitx.conf
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
EOF

sudo pacman -S flameshot dunst --noconfirm
mkdir -p ${HOME}/Pictures/screenshots
./configs/dunst/config.sh
./configs/git/config.sh
./installer/fzf/install.sh


