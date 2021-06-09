#!/bin/sh
set -e

# download 'msyh.ttc' font

# set wechat font setting
cat << EOF > /tmp/msyh_config.reg
REGEDIT4
[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink]
"Lucida Sans Unicode"="msyh.ttf"
"Microsoft Sans Serif"="msyh.ttf"
"MS Sans Serif"="msyh.ttf"
"Tahoma"="msyh.ttf"
"Tahoma Bold"="msyhbd.ttf"
"msyh"="msyh.ttf"
"Arial"="msyh.ttf"
"Arial Black"="msyh.ttf"
EOF

env WINEPREFIX="$HOME/.deepinwine/Deepin-WeChat" deepin-wine5 regedit /tmp/msyh_config.reg
