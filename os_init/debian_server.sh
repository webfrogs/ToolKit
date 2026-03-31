#!/bin/sh
set -e

cd $(dirname $0)
cd ..
RootPath=$(pwd)

if test "$(uname -s)" != "Linux"; then
  echo "[ERROR] Current OS is not Linux"
  exit 1
fi

if test ! -x "$(command -v apt)"; then
  echo "[ERROR] apt command is not found."
  exit 1
fi

sudo apt update

sudo apt install -y \
  make htop zsh

./configs/git/config.sh
./installer/fzf/install.sh
./installer/docker/install.sh



