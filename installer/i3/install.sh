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
	if test -x "$(command -v apt-get)"; then
		ubuntuCodeName=$(lsb_release -cs)
		if test -f "/etc/lsb-release"; then
			distribID=$(grep "DISTRIB_ID" /etc/lsb-release | awk -F"=" '{ print $2 }')
			if test ${distribID} = "LinuxMint"; then
				ubuntuCodeName=$(grep "UBUNTU_CODENAME" /etc/os-release | awk -F"=" '{ print $2 }')
			fi
		fi

		cd /tmp
		/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2020.02.03_all.deb keyring.deb SHA256:c5dd35231930e3c8d6a9d9539c846023fe1a08e4b073ef0d2833acd815d80d48
		sudo dpkg -i ./keyring.deb
		echo "deb https://debian.sur5r.net/i3/ ${ubuntuCodeName} universe" \
				| sudo tee /etc/apt/sources.list.d/sur5r-i3.list > /dev/null
		sudo apt update
		sudo apt install -y i3
		sudo apt install -y dmenu
		sudo apt-get install -y i3status
		sudo apt-get install -y i3lock
  elif test -x "$(command -v pacman)"; then
    sudo pacman -Syy
    sudo pacman -S --noconfirm i3-wm i3lock i3status dmenu i3status-rust
    sudo pacman -S --noconfirm \
      feh variety network-manager-applet picom polybar rofi xorg-xrandr
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


mkdir -p ${HOME}/.config/i3status-rust
rm -f ${HOME}/.config/i3status-rust/config.toml
cp ${workDir}/res/i3status-rust-config.toml ${HOME}/.config/i3status-rust/config.toml
battery_count=$(find -L /sys/class/power_supply/ -maxdepth 1 -type d -name 'BAT*' | wc -l)
if test "$battery_count" -gt 0; then
  # has battery
  echo "adding battery status to i3status..."
  time_block_line_num=$(awk '/^block = "time"/ {print FNR}' ${HOME}/.config/i3status-rust/config.toml)
  sed -i "$(expr ${time_block_line_num} - 2)"'a[[block]]\
block = "battery"\
driver = "upower"          # 推荐用 upower，可自动聚合多电池；也可选 "sysfs"\
device = "DisplayDevice"   # upower 的聚合设备；单电池可留空或写 BAT0\
interval = 10              # 仅 driver=sysfs/apc_ups 时有效，单位秒\
format = " $icon $percentage {$time |}"   # 普通状态\
charging_format = " $icon $percentage ⚡ {$time |}"   # 充电状态\
full_format = " $icon $percentage ✔"      # 充满状态\
empty_format = " $icon $percentage ▇"     # 电量低状态\
missing_format = ""        # 未检测到电池时不显示任何内容\
\
# 电量阈值（百分比）及对应颜色\
info = 60     # ≥60% 视为 info 色（蓝）\
good = 60     # ≥60% 视为 good 色（绿）\
warning = 30  # ≥30% 视为 warning 色（黄）\
critical = 15 # ≤15% 视为 critical 色（红）\
\
# 充满/放空的判定阈值\
full_threshold = 95   # ≥95% 即认为充满，切换为 full_format\
empty_threshold = 7.5 # ≤7.5% 即认为放空，切换为 empty_format\
' ${HOME}/.config/i3status-rust/config.toml
fi

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
if test -n "${newDPI}"; then
  sed -i '/^Xft\.dpi:/d' $HOME/.Xresources
  echo "Xft.dpi: ${newDPI}" | tee -a $HOME/.Xresources
  echo "HiDPI is configured, reboot to make it work."
fi

