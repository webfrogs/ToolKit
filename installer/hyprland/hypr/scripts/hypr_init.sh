#!/bin/sh
set -e

# 这个脚本在 hyprland 启动时调用，用于启动常用应用
hyprctl dispatch exec "[workspace 4 silent] thunderbird"
hyprctl dispatch exec "[workspace 1 silent] kitty"

hyprctl dispatch workspace 1
# hyprctl dispatch group set
