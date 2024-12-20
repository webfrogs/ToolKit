#!/bin/bash
set -e

if [ ! `whoami` == "root" ]; then
    echo "[ERROR] Shell should be executed by root."
    exit 1
fi

proxy_addr=$1
if test -z "${proxy_addr}"; then
  proxy_addr="127.0.0.1:1090"
fi
echo "proxy address: ${proxy_addr}"

mkdir -p /etc/systemd/system/docker.service.d/
cat << EOF > /etc/systemd/system/docker.service.d/override.conf
[Service]
Environment="HTTP_PROXY=http://${proxy_addr}/" "HTTPS_PROXY=http://${proxy_addr}/" "NO_PROXY=localhost,127.0.0.1,docker.servicewall.cn"
EOF

systemctl daemon-reload
systemctl restart docker

echo "docker daemon proxy is set to ${proxy_addr}"
