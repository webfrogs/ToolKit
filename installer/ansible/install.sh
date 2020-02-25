#!/bin/sh
set -e


case "$(uname -s)" in
	Linux)
		if test -x "$(command -v apt-get)"; then
			sudo apt update
			sudo apt install software-properties-common
			sudo apt-add-repository -y update ppa:ansible/ansible
			sudo apt update
			sudo apt install -y ansible
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
