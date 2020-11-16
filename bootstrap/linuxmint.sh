#!/bin/sh
set -e

cd $(dirname $0)
cd ..
RootPath=$(pwd)

if test "$(uname -s)" != "Linux"; then
  echo "[ERROR] Current OS is not Linux"
  exit 2
fi

if test ! -x "$(command -v apt)"; then
  echo "[ERROR] apt command is not found."
  exit 2
fi

sudo apt-get update
sudo apt-get -y install \
  git build-essential automake autoconf resolvconf \
  pkg-config vim cmake python python-dev zsh

if [ ! -d "$HOME/.fzf" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
  $HOME/.fzf/install --all
fi

./configs/git/config.sh
./configs/zsh/config.sh

./installer/fzf/install.sh
./installer/docker/install.sh
./installer/nodejs/install.sh
./installer/neovim/install.sh

