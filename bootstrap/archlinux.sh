#!/bin/sh
set -e

cd $(dirname $0)
cd ..
projectRoot=$(pwd)

if test "$(uname -s)" != "Linux"; then
  echo "[ERROR] Current OS is not Linux"
  exit 1
fi

if test ! -x "$(command -v pacman)"; then
  echo "[ERROR] pacman command is not found."
  exit 1
fi

# check proxys
echo "==> checking proxy"
read -p "Use proxy? [y/n]: " use_proxy
if test "${use_proxy}" = "y"; then
  echo "Default http proxy address is 127.0.0.1:1090"
  read -p "Input http proxy address, or press enter directly to use default proxy: " proxy_addr
  if test -z "${proxy_addr}"; then
    proxy_addr="127.0.0.1:1090"
  fi
  export http_proxy="http://${proxy_addr}"
  export https_proxy="http://${proxy_addr}"
  echo "http proxy is set to 'http://${proxy_addr}'"
else
  echo "No proxy is set."
fi

echo "==> start to bootstrap archlinux."
sudo pacman -Syy

echo "==> add archlinuxcn pacman source."
if grep -Fxq "[archlinuxcn]" /etc/pacman.conf; then
	echo "[INFO] archlinux cn already exists in file '/etc/pacman.conf'"
else
	echo "[archlinuxcn]" | sudo tee -a /etc/pacman.conf
	echo "SigLevel = Optional TrustedOnly" | sudo tee -a /etc/pacman.conf
	echo 'Server = http://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch' | sudo tee -a /etc/pacman.conf
  sudo pacman -Syy
	sudo pacman -S archlinuxcn-keyring haveged --noconfirm

  # fix archlinuxcn key can not import
  # see https://www.archlinuxcn.org/gnupg-2-1-and-the-pacman-keyring/
  sudo systemctl enable --now haveged
  sudo rm -rf /etc/pacman.d/gnupg
  sudo pacman-key --init
  sudo pacman-key --populate archlinux
  sudo pacman-key --populate archlinuxcn
fi

# install necessary packages
echo "==> install necessary packages."
sudo pacman -S --noconfirm \
  base-devel cmake \
  curl wget openssh less \
  git vim zip tree unzip jq \
  terminator hexchat zsh \
  resolvconf net-tools \
  dnsutils iputils socat \
  blueman bluez-utils \
  usbutils lshw \
  sddm network-manager-applet xorg-xrandr

# install chinese input method
sudo pacman -S fcitx-im fcitx-configtool fcitx-sunpinyin --noconfirm

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

# set ssh github proxy
if test -n "${proxy_addr}"; then
  HTTP_PROXY_ADDR=${proxy_addr} ./configs/ssh/github_proxy_set.sh
fi

sudo pacman -S flameshot dunst --noconfirm
./configs/dunst/config.sh
./configs/git/config.sh
./installer/fzf/install.sh
./configs/zsh/config.sh

mkdir -p ${HOME}/Pictures/screenshots
