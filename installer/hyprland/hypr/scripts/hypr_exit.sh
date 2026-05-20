#!/bin/sh
set -e

if zenity --question --text="确定要退出 Hyprland 吗？" --title="需要确认" --ok-label=退出 --cancel-label=取消; then
  hyprctl dispatch 'hl.dsp.exit()'
fi

