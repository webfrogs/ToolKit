#!/bin/bash
set -e

read -p "input vnc password: " -s pwd
echo ""
read -p "verify vnc password: " -s confirmPwd
echo ""

if test "$pwd" != "$confirmPwd"; then
  echo "password not match."
  exit 1
fi

sudo pacman -Syy tigervnc --noconfirm

sudo mkdir -p /root/.vnc
echo -n "$pwd" | vncpasswd -f | sudo tee /root/.vnc/passwd > /dev/null

sudo tee /etc/systemd/system/x0vncserver.service >/dev/null <<'EOF'
[Unit]
Description=Remote desktop service (VNC) for :0 display
Requires=display-manager.service
After=network-online.target
After=display-manager.service

[Service]
Type=simple
ExecStartPre=/usr/bin/bash -c "/usr/bin/systemctl set-environment XAUTHORITY=$(find /var/run/sddm/ -type f)"
Environment=HOME=/root
ExecStart=x0vncserver -display :0 -rfbauth /root/.vnc/passwd
Restart=on-failure
RestartSec=500ms

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now x0vncserver.service

echo "tigervnc is installed."
