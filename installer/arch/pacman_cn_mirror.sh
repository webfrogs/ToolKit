#!/bin/sh
set -e


if test ! -x "$(command -v pacman-mirrors)"; then
  echo "'pacman-mirrors' command is not found"
  exit
fi

sudo pacman-mirrors -i -c China -m rank
sudo pacman -Syy
sudo pacman -Syu --noconfirm
