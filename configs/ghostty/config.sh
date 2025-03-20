#!/bin/sh
set -e

current_folder=$(cd $(dirname $0) && pwd)
config_path=$HOME/.config/ghostty/config

if test -f ${config_path}; then
  rm -f ${config_path}
fi

mkdir -p $HOME/.config/ghostty
ln -sf ${current_folder}/_config ${config_path}
echo "Done!"

