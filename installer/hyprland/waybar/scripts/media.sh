#!/bin/sh

# 获取当前播放状态和元数据
player_status=$(playerctl status 2>/dev/null)
if [ "$player_status" = "" ]; then
    echo ""
    exit
fi

artist=$(playerctl metadata artist 2>/dev/null)
title=$(playerctl metadata title 2>/dev/null)
status_icon=""
case "$player_status" in
    "Playing") status_icon="" ;;
    "Paused")  status_icon="" ;;
    "Stopped") status_icon="" ;;
    *)         status_icon="" ;;
esac

# 显示格式，例如：▶ Artist - Title
if [ -n "$artist" ] && [ -n "$title" ]; then
    echo "$status_icon $artist|$title"
else
    # 如果没有元数据，只显示状态
    echo "$status_icon Music"
fi
