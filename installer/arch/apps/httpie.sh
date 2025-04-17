#!/bin/sh
set -e

yay -S --noconfirm httpie-desktop-bin
httpie plugins install httpie-websockets

