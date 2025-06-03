#!/bin/sh
set -e

sudo pacman -Syy
sudo pacman -S dkms bc linux-lts-headers

