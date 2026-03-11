#!/bin/sh
set -e

aur_pkg_cmd=""
if test -x "$(command -v paru)"; then
  aur_pkg_cmd="paru"
elif test -x "$(command -v yay)"; then
  aur_pkg_cmd="yay"
else
  echo "ERROR! not found paru or yay"
  exit 1
fi

${aur_pkg_cmd} -S --noconfirm $@
