#!/bin/sh
set -e

case "$(uname -s)" in
	Darwin)
			echo "[ERROR] No package management tools found."
			exit 2
		;;
	Linux)
		if test -x "$(command -v apt-get)"; then
			echo "Not support yet."
			exit 2
		elif test -x "$(command -v yum)"; then
			echo "Not support yet."
			exit 2
		elif test -x "$(command -v pacman)"; then
      curl -o /tmp/dropbox-key.asc  https://linux.dropbox.com/fedora/rpm-public-key.asc
      gpg --import /tmp/dropbox-key.asc
      rm -f /tmp/dropbox-key.asc
      rm -rf /tmp/dropbox
      cd /tmp
      git clone https://aur.archlinux.org/dropbox.git
      cd dropbox/
      makepkg -si
		else
			echo "[ERROR] No package management tools found."
			exit 2
		fi
		;;
	*)
		echo "Unsupported OS is found."
		exit 2
		;;
esac
