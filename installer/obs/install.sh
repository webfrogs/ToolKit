#!/bin/bash
set -e


case "$(uname -s)" in
	Darwin)
		echo "[ERROR] macOS is not supported yet."
		exit 2
		;;
	Linux)
		if test -x "$(command -v apt-get)"; then
      sudo apt install -y ffmpeg
      sudo add-apt-repository ppa:obsproject/obs-studio
      sudo apt install obs-studio
		elif test -x "$(command -v pacman)"; then
      sudo pacman -S obs-studio --noconfirm
		else
			echo "[ERROR] No package management tools found."
			exit 2
		fi
		;;
	*)
		echo "[ERROR] Unsupported OS is found."
		exit 2
		;;
esac
