#!/bin/bash
set -e

if test ! -x "$(command -v docker)"; then
  echo "ERROR! docker is not installed."
  exit 1
fi

if test -x "$(command -v pacman)"; then
  sudo pacman -S --noconfirm docker-buildx docker-compose \
    qemu-user-static qemu-user-static-binfmt
else
  echo "ERROR! not found supported package manager"
  exit 1
fi

# config qemu for docker
docker run --pull=always --rm --privileged multiarch/qemu-user-static --reset -p yes

