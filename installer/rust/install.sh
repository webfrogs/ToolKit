#!/bin/sh
set -e


if test -x "$(command -v pacman)"; then
  sudo pacman -Syy
  sudo pacman -S rustup
  rustup default stable
else
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

