#!/bin/bash
set -e

RELOGIN=false
for arg in "$@"; do
    if [[ "$arg" == "relogin" ]]; then
        RELOGIN=true
    fi
done

cd $(dirname $0)
CURRENT_PATH=$(pwd)

# this device should rotate to left
# use command 'xrandr' to find monitor
sudo tee /etc/X11/xorg.conf.d/10-monitor.conf >/dev/null <<EOF
Section "Monitor"
    Identifier "eDp-1"
    Option "Rotate" "left"
EndSection
EOF

# 1. use command 'xinput list' to find touchscreen name
# 2. config xorg to rotate touchscreen
sudo tee /etc/X11/xorg.conf.d/99-touchscreen-rotation.conf >/dev/null <<EOF
Section "InputClass"
    Identifier      "Touchscreen rotation"
    MatchProduct    "NVTK0603:00 0603:F001"
    Option          "TransformationMatrix" "0 -1 1 1 0 0 0 0 1"
EndSection
EOF

../bin/disable_system_sleep.sh
../bin/sddm_hidpi_support.sh

sudo mkdir -p /etc/sddm.conf.d
sudo tee /etc/sddm.conf.d/Xsetup >/dev/null <<EOF
#!/bin/sh
xset s off         # 关闭屏幕保护
xset -dpms         # 关闭 DPMS（电源管理）
xset s noblank     # 禁止屏幕变黑
EOF

# sudo tee /etc/profile.d/99-x1.sh >/dev/null <<EOF
# export GDK_SCALE=1.5
# EOF

if [[ "$RELOGIN" == true ]]; then
    sudo systemctl restart sddm
fi
