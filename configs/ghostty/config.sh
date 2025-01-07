#!/bin/sh
set -e

current_folder=$(cd $(dirname $0) && pwd)
config_path=~/.config/ghostty/config

if test -f ${config_path}; then
  rm -f ${config_path}
fi

ln -sf ${current_folder}/_config ${config_path}
echo "Done!"

