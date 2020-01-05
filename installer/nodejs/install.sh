#!/bin/sh
set -e

if test -x "$(command -v node)"; then
	echo "===> Nodejs has been installed."
	exit
fi

if test -x "$(command -v apt-get)"; then
	sudo apt-get install -y gcc make g++
else
	echo "===> ERROR! Installation is not supported for current OS."
	exit 2
fi

rm -rf /tmp/nodejs/
mkdir -p /tmp/nodejs
cd /tmp/nodejs
curl -o node.tar.gz https://nodejs.org/dist/v12.14.0/node-v12.14.0.tar.gz
tar xzf node.tar.gz
rm node.tar.gz
cd $(ls)
./configure
make -j4
sudo make install


