#!/bin/sh
set -e

cd $(dirname $0)
cd ..
RootPath=$(pwd)

if test "$(uname -s)" != "Linux"; then
  echo "[ERROR] Current OS is not Linux"
  exit 2
fi

if test ! -x "$(command -v apt-get)"; then
  echo "[ERROR] apt-get command is not found."
  exit 2
fi

sudo apt-get update
sudo apt-get -y install \
	git build-essential automake autoconf resolvconf \
	pkg-config vim cmake python python-dev zsh terminator

if [ ! -d "$HOME/.fzf" ]; then
	git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
	$HOME/.fzf/install --all
fi


./configs/git/git-configer.sh
./configs/zsh/config.sh

echo "[INFO] All finished."
