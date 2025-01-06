#!/bin/sh
set -e

yay -S wps-office --noconfirm

# Zh-CN language support
yay -S wps-office-mui-zh-cn --noconfirm

# fix export to pdf failed issue
yay -S --noconfirm libtiff5
