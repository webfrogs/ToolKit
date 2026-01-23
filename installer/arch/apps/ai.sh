#!/bin/sh
set -e

cd $(dirname $0)

paru -S opencode-bin
bunx oh-my-opencode install
# ../bin/aur_install.sh 

