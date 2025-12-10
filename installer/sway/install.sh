#!/bin/bash
set -e

cd $(dirname $0)
current_dir=$(pwd)

installNeed="y"
if test -x "$(command -v sway)"; then
	echo "[INFO] sway has been installed."
	read -p "Need reinstall? [y/n] " installNeed
fi

if test "${installNeed}" = "y"; then
	if test -x "$(command -v pacman)"; then
    sudo pacman -Syy
    sudo pacman -S --noconfirm \
      sway swaylock wlroots \
      xorg-xwayland xorg-xlsclients qt5-wayland qt6-wayland \
      fuzzel waybar wl-clipboard \
      grim slurp swappy \
      ttf-jetbrains-mono-nerd \
      brightnessctl mako
	else
		echo "no supported package manager found."
		exit 1
	fi
fi

rm -rf ${HOME}/.config/sway
ln -sf ${current_dir}/config ${HOME}/.config/sway

# handle monitor conf
if test -e config/conf/monitor -a ! -L config/conf/monitor; then
  rm -f config/conf/monitor
fi
if test ! -e config/conf/monitor; then 
  ln -sf ./monitors/default config/conf/monitor
fi

# config waybar
rm -rf ${HOME}/.config/waybar
ln -sf ${current_dir}/waybar ${HOME}/.config/waybar

# config mako
rm -rf ${HOME}/.config/mako
ln -sf ${current_dir}/mako ${HOME}/.config/mako

echo "==> All done!"
