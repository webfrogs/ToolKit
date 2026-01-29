#!/bin/sh
set -e

# wiki: https://wiki.archlinuxcn.org/wiki/WPS_Office
cd $(dirname $0)
../bin/aur_install.sh wps-office-cn wps-office-fonts wps-office-mui-zh-cn libtiff5
