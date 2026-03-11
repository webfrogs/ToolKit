#!/bin/sh
set -e

# wiki: https://wiki.archlinuxcn.org/wiki/WPS_Office
cd $(dirname $0)
../bin/aur_install.sh wps-office-cn wps-office-fonts wps-office-mui-zh-cn libtiff5

if test -f "~/.config/Kingsoft/Office.conf"; then
  sed -i '/^wpsoffice\\Application%20Settings\\AppComponentMode/d' ~/.config/Kingsoft/Office.conf
  sed -i '/^\[6\.0\]/a\wpsoffice\\Application%20Settings\\AppComponentMode=prome_independ' ~/.config/Kingsoft/Office.conf
fi
