#!/bin/sh
set -e


case "$(uname -s)" in
	Linux)
		if test -x "$(command -v apt-get)"; then
			sudo apt update -y
			sudo apt install wireguard resolvconf -y
    elif test -x "$(command -v pacman)"; then
      sudo pacman -Syy wireguard-tools
		else
			echo "ERROR! unsupport package manager"
			exit 2
		fi
		;;
	*)
		echo "ERROR! unsupport OS!"
		exit 2
		;;
esac
