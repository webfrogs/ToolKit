#!/bin/sh
set -e

current_folder=$(cd $(dirname $0) && pwd)


ghostty_config_path=$HOME/.config/ghostty/config.ghostty
rm -f $HOME/.config/ghostty/config
rm -f $HOME/.config/ghostty/config.ghostty
mkdir -p $(dirname ${ghostty_config_path})
ln -sf ${current_folder}/ghostty/config.ghostty ${ghostty_config_path}

kitty_config_folder=$HOME/.config/kitty
if test -e ${kitty_config_folder}; then
  rm -rf ${kitty_config_folder}
fi
mkdir -p $(dirname ${kitty_config_folder})
ln -sf ${current_folder}/kitty ${kitty_config_folder}

tmux_config_path=$HOME/.config/tmux/tmux.conf
rm -f ${tmux_config_path}
mkdir -p $(dirname ${tmux_config_path})
ln -sf ${current_folder}/tmux/tmux.conf ${tmux_config_path}

echo "Done!"

