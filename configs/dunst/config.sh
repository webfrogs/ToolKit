#!/bin/bash
set -e

cd $(dirname $0)
mkdir -p ~/.config/dunst
ln -sf $(pwd)/res/dunstrc ~/.config/dunst/dunstrc


