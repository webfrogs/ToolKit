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

# install necessary packages
echo "==> install necessary packages."
mkdir -p ${HOME}/Pictures/screenshots

sudo pacman -S --noconfirm \
  base-devel cmake \
  curl wget openssh less \
  git vim zip tree unzip jq \
  terminator hexchat zsh aria2 \
  resolvconf net-tools \
  dnsutils iputils socat \
  blueman bluez-utils bluez-deprecated-tools bluez-hid2hci \
  usbutils lshw htop \
  pipewire-pulse \
  network-manager-applet xorg-xrandr xorg-xrdb xorg-xdpyinfo

# pulseaudio-alsa

sudo systemctl enable --now bluetooth

# set ssh github proxy
if test -n "${proxy_addr}"; then
  ./configs/git/force_ssh_for_github.sh
  HTTP_PROXY_ADDR=${proxy_addr} ./configs/ssh/github_proxy_set.sh
  if test ! -f "${HOME}/.ssh/known_hosts"; then
    touch ${HOME}/.ssh/known_hosts
  fi
  sed -i '/^github.com/d' ${HOME}/.ssh/known_hosts
  ssh-keyscan -t ed25519 github.com | grep -v '^#' >> ${HOME}/.ssh/known_hosts
fi

sudo pacman -S flameshot dunst --noconfirm
./configs/dunst/config.sh
./configs/git/config.sh
./installer/fzf/install.sh
./installer/docker/install.sh
./configs/zsh/config.sh

