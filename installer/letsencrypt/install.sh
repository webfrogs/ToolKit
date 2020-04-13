#!/bin/sh
set -e

if test -x "$(command -v certbot)"; then
	echo "====> [INFO] Certbot already exists."
	exit
fi

case "$(uname -s)" in
	Linux)
		if test -x "$(command -v apt-get)"; then
			sudo apt-get update -y
			sudo apt-get install -y software-properties-common
			sudo add-apt-repository -y universe
			sudo add-apt-repository -y ppa:certbot/certbot
			sudo apt-get update -y

			sudo apt-get install -y certbot python-certbot-nginx
		elif test -x "$(command -v yum)"; then
			echo "====> [ERROR] Yum is not supported yet."
			exit 2
		else
			echo "====> [ERROR] Not found any supported package management tool."
			exit 2
		fi
		;;
	*)
		echo "====> [ERROR] Current OS is not supported."
		exit 2
		;;
esac
