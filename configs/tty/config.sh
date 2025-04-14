#!/bin/sh
set -e

current_folder=$(cd $(dirname $0) && pwd)

ghostty_config_path=$HOME/.config/ghostty/config
if test -f ${ghostty_config_path}; then
  rm -f ${ghostty_config_path}
fi
mkdir -p $(dirname ${ghostty_config_path})
ln -sf ${current_folder}/ghostty_config ${ghostty_config_path}

kitty_config_path=$HOME/.config/kitty/kitty.conf
if test -f ${kitty_config_path}; then
  rm -f ${kitty_config_path}
fi
mkdir -p $(dirname ${kitty_config_path})
ln -sf ${current_folder}/kitty_config ${kitty_config_path}
echo "Done!"

