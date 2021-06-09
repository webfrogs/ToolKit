#!/bin/bash
set -e

case "$(uname -s)" in
	Linux)
		if test -x "$(command -v apt-get)"; then
			echo "[ERROR] unsupport package manager"
			exit 2
    elif test -x "$(command -v pacman)"; then
      sudo pacman -S snapd --noconfirm
      sudo systemctl enable --now snapd.socket
		else
			echo "[ERROR] unsupport package manager"
			exit 2
		fi
		;;
	*)
		echo "[ERROR] unsupport OS!"
		exit 2
		;;
esac

