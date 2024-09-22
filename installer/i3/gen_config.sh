#!/bin/bash
set -e

cd $(dirname $0)
mkdir -p config
rm config/*

cp res/config config/1080p

cp res/config config/2k
sed -i 's/^exec xrandr --dpi.*$/exec xrandr --dpi 150/g' config/2k

cp res/config config/4k
sed -i 's/^exec xrandr --dpi.*$/exec xrandr --dpi 175/g' config/4k


