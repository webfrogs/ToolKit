#!/bin/bash
set -e

if [ ! `whoami` == "root" ]; then
    echo "[ERROR] Shell should be executed by root."
    exit 1
fi

cat << EOF > /etc/systemd/system/docker.service.d/override.conf
[Service]
Environment="HTTP_PROXY=http://127.0.0.1:1089/" "HTTPS_PROXY=http://127.0.0.1:1089/" "NO_PROXY=localhost,127.0.0.1,docker-registry.somecorporation.com,docker.servicewall.cn"
EOF

systemctl daemon-reload
systemctl restart docker
