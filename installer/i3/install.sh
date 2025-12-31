#!/bin/bash
set -e

cd $(dirname $0)
workDir=$(pwd)

installNeed="y"
if test -x "$(command -v i3)"; then
	echo "[INFO] i3 has been installed."
	read -p "Need reinstall? [y/n] " installNeed
fi

if test "${installNeed}" = "y"; then
	if test -x "$(command -v pacman)"; then
    sudo pacman -Syy
    sudo pacman -S --noconfirm i3-wm i3lock \
      picom polybar rofi
    sudo pacman -S --noconfirm \
      flameshot dunst \
      xorg-xprop xorg-xrandr \
      feh network-manager-applet
	else
		echo "Can not install in current OS"
		exit 1
	fi
fi

mkdir -p ${HOME}/Pictures/wallpapers

echo ""
echo "[INFO] install i3 config file"
if test -d "${HOME}/.config/i3"; then
  rm -rf "${HOME}/.config/i3"
fi
ln -sf ${workDir}/i3wm ${HOME}/.config/i3

# picom config
if test -d "${HOME}/.config/picom"; then
  rm -rf ${HOME}/.config/picom
fi
ln -sf ${workDir}/picom ${HOME}/.config/picom

# rofi config
if test -d "${HOME}/.config/rofi"; then
  rm -rf ${HOME}/.config/rofi
fi
ln -sf ${workDir}/rofi ${HOME}/.config/rofi

# polybar config
if test -d "${HOME}/.config/polybar"; then
  rm -rf ${HOME}/.config/polybar
fi
ln -sf ${workDir}/polybar ${HOME}/.config/polybar

# dunst config(notification service)
if test -d "${HOME}/.config/dunst"; then
  rm -rf ${HOME}/.config/dunst
fi
ln -sf ${workDir}/dunst ${HOME}/.config/dunst

echo "[INFO] i3 config file is installed successfully."

# fix i3wm dmenu input issue
if test ! -e "${HOME}/.xprofile"; then
  touch ${HOME}/.xprofile
fi
if test "$(grep -c '^export GTK_IM_MODULE=fcitx' ${HOME}/.xprofile)" = "0"; then
	echo "export GTK_IM_MODULE=fcitx" | tee -a ${HOME}/.xprofile > /dev/null
fi
if test "$(grep -c '^export QT_IM_MODULE=fcitx' ${HOME}/.xprofile)" = "0"; then
	echo "export QT_IM_MODULE=fcitx" | tee -a ${HOME}/.xprofile > /dev/null
fi
if test "$(grep -c '^export XMODIFIERS=@im=fcitx' ${HOME}/.xprofile)" = "0"; then
	echo "export XMODIFIERS=@im=fcitx" | tee -a ${HOME}/.xprofile > /dev/null
fi
if test "$(grep -c '^export SDL_IM_MODULE=fcitx' ${HOME}/.xprofile)" = "0"; then
	echo "export SDL_IM_MODULE=fcitx" | tee -a ${HOME}/.xprofile > /dev/null
fi
if test "$(grep -c '^export GLFW_IM_MODULE=ibus' ${HOME}/.xprofile)" = "0"; then
	echo "export GLFW_IM_MODULE=ibus" | tee -a ${HOME}/.xprofile > /dev/null
fi

if test ! -e "$HOME/.Xresources"; then
  touch "$HOME/.Xresources"
fi
echo ""
echo "[INFO] HiDPI support."
echo "choose HiDPI screen resolution(default 1080p):"
echo "  1. 2k"
echo "  2. 4k"
read -p "Which one do you choose: " hidpiIndex
case "${hidpiIndex}" in
  1)
    # 2k
    newDPI="150"
    ;;
  2)
    # 4k
    newDPI="175"
    ;;
	*)
    echo "Skip HiDPI configuration."
    ;;
esac
sed -i '/^Xft\.dpi:/d' $HOME/.Xresources # remove it to set as 1080p
if test -n "${newDPI}"; then
  echo "Xft.dpi: ${newDPI}" | tee -a $HOME/.Xresources
  echo "HiDPI is configured, reboot to make it work."
fi

