#!/bin/sh
set -e

sudo pacman -Syy
sudo pacman-mirrors -i -c China -m rank
