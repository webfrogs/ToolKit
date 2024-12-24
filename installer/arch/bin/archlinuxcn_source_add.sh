#!/bin/sh
set -e

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
