#!/bin/sh
set -e

cd /tmp
rm -rf visual-studio-code-bin
git clone https://aur.archlinux.org/visual-studio-code-bin.git
cd visual-studio-code-bin/
makepkg -si
