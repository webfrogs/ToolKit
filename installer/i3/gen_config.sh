#!/bin/bash
set -e

cd $(dirname $0)
mkdir -p config

# config for manjaro
cp res/config config/manjaro

# config for manjaro_4k
cp res/config config/manjaro_4k
sed -i 's/^exec xrandr --dpi.*$/exec xrandr --dpi 220/g' config/manjaro_4k

# config for linux_mint
cp res/config config/linux_mint

