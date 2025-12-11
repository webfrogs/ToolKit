#!/bin/bash
set -e
set -o pipefail

cd $(dirname $0)
current_dir=$(pwd)

installNeed="y"
if test -x "$(command -v hyprland)"; then
	echo "[INFO] hyprland has been installed."
	read -p "Need reinstall? [y/n] " installNeed
fi

if test "${installNeed}" = "y"; then
  echo "==> install necessary packages."
	if test -x "$(command -v pacman)"; then
    sudo pacman -Syy
    sudo pacman -S --noconfirm \
      hyprland hyprlock \
      xorg-xwayland xorg-xlsclients xorg-xrdb qt5-wayland qt6-wayland \
      fuzzel waybar wl-clipboard \
      brightnessctl \
      ttf-jetbrains-mono-nerd
  else
		echo "no supported package manager found."
		exit 1
  fi
fi

rm -rf ${HOME}/.config/hypr
ln -sf ${current_dir}/config ${HOME}/.config/hypr

# handle monitor conf
if test -e config/conf/monitor.conf -a ! -L config/conf/monitor.conf; then
  rm -f config/conf/monitor.conf
fi
if test ! -e config/conf/monitor.conf; then 
  ln -sf ./monitors/default.conf config/conf/monitor.conf
fi

# config waybar
rm -rf ${HOME}/.config/waybar
ln -sf ${current_dir}/waybar ${HOME}/.config/waybar

echo "==> All done!"
