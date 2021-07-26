#!/bin/bash
set -e

convert -resize $(xdpyinfo | grep dimensions | cut -d\  -f7 | cut -dx -f1) lock.jpg lock.png
