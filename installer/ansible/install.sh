#!/bin/sh
set -e


case "$(uname -s)" in
	Linux)
		if test -x "$(command -v apt-get)"; then
      sudo apt update
      sudo apt install -y software-properties-common
      sudo apt-add-repository -y ppa:ansible/ansible
      sudo apt update
      sudo apt install -y ansible
    elif test -x "$(command -v pacman)"; then
      sudo pacman -Syy ansible
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
