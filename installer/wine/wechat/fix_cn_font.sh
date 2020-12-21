#!/bin/sh
set -e

# download 'msyh.ttc' font

# set wechat font setting
cat << EOF > /tmp/msyh_config.reg
REGEDIT4
[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink]
"Lucida Sans Unicode"="msyh.ttc"
"Microsoft Sans Serif"="msyh.ttc"
"MS Sans Serif"="msyh.ttc"
"Tahoma"="msyh.ttc"
"Tahoma Bold"="msyhbd.ttc"
"msyh"="msyh.ttc"
"Arial"="msyh.ttc"
"Arial Black"="msyh.ttc"
EOF

env WINEPREFIX="$HOME/.deepinwine/Deepin-WeChat" deepin-wine5 regedit /tmp/msyh_config.reg
