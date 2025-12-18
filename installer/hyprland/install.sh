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
      hyprland hyprlock hyprpicker \
      xorg-xwayland xorg-xlsclients xorg-xrdb \
      hyprpolkitagent \
      xdg-desktop-portal-hyprland wireplumber xdg-desktop-portal-wlr \
      qt5-wayland qt6-wayland \
      fuzzel waybar mako \
      wl-clipboard cliphist \
      grim slurp satty \
      brightnessctl \
      ttf-jetbrains-mono-nerd
  else
		echo "no supported package manager found."
		exit 1
  fi
fi

mkdir -p ~/Pictures/Screenshots

rm -rf ${HOME}/.config/hypr
ln -sf ${current_dir}/hypr ${HOME}/.config/hypr

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

# config mako
rm -rf ${HOME}/.config/mako
ln -sf ${current_dir}/mako ${HOME}/.config/mako

# config fuzzel
rm -rf ${HOME}/.config/fuzzel
ln -sf ${current_dir}/fuzzel ${HOME}/.config/fuzzel

newDPI=""
echo "Choose HiDPI screen resolution for xwayland(default 1080p):"
echo "  1. 1080p"
echo "  2. 2k"
echo "  3. 4k"
read -p "Which one do you choose: " hidpiIndex
case "${hidpiIndex}" in
  1)
    # 1080p
    newDPI="96"
    ;;
  2)
    # 2k
    newDPI="150"
    ;;
  3)
    # 4k
    newDPI="175"
    ;;
	*)
    newDPI="96"
    echo "use default HiDPI for 1080p"
    ;;
esac
if test -n "${newDPI}"; then
  echo "Xft.dpi: ${newDPI}" | tee -a $HOME/.config/hypr/.Xresources
  echo "HiDPI is configured, reboot to make it work."
fi

echo "==> All done!"
