#!/bin/sh
set -e

cd $(dirname $0)
../bin/aur_install.sh microsoft-edge-stable-bin
