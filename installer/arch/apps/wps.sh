#!/bin/sh
set -e

cd $(dirname $0)
../bin/aur_install.sh wps-office wps-office-mui-zh-cn libtiff5
