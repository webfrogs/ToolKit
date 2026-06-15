#!/bin/bash
set -e
set -o pipefail

# AUR helper: prefer paru over yay
aur() {
  if command -v paru &>/dev/null; then
    paru "$@"
  elif command -v yay &>/dev/null; then
    yay "$@"
  else
    echo "[ERROR] No AUR helper found. Please install paru or yay."
    exit 1
  fi
}

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
      hyprland hyprlock hyprpicker hyprpaper \
      xorg-xwayland xorg-xlsclients xorg-xrdb \
      hyprpolkitagent \
      xdg-desktop-portal-hyprland wireplumber xdg-desktop-portal-wlr \
      qt5-wayland qt6-wayland \
      fuzzel waybar mako \
      wl-clipboard cliphist \
      grim slurp satty \
      brightnessctl \
      playerctl \
      zenity \
      thunar tumbler ffmpegthumbnailer poppler-glib gvfs-smb file-roller thunar-archive-plugin gvfs-mtp libmtp \
      ttf-jetbrains-mono-nerd
  else
		echo "no supported package manager found."
		exit 1
  fi
  aur -S --noconfirm mark-shot
fi

mkdir -p ~/Pictures/Screenshots

rm -rf ${HOME}/.config/hypr
ln -sf ${current_dir}/hypr ${HOME}/.config/hypr

# handle monitor conf
rm -f hypr/conf/monitor.conf
if test -e hypr/conf/monitor.lua -a ! -L hypr/conf/monitor.lua; then
  rm -f hypr/conf/monitor.lua
fi
if test ! -e hypr/conf/monitor.lua; then 
  ln -sf ./monitors/default.lua hypr/conf/monitor.lua
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

echo "==> All done!"
