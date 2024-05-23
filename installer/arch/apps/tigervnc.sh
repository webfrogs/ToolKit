#!/bin/bash
set -e

sudo pacman -Syy tigervnc --noconfirm

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

echo "tigervnc is installed."
echo "1. change user to root and run command 'vncpasswd'"
echo "2. run 'sudo systemctl start x0vncserver.service' to start vnc server at port 5900"
