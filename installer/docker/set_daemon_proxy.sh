#!/bin/bash
set -e

proxy_addr=$1
if test -z "${proxy_addr}"; then
  proxy_addr="127.0.0.1:1090"
fi
echo "proxy address: ${proxy_addr}"

sudo mkdir -p /etc/systemd/system/docker.service.d/
cat << EOF | sudo tee /etc/systemd/system/docker.service.d/override.conf >/dev/null
[Service]
Environment="HTTP_PROXY=http://${proxy_addr}/" "HTTPS_PROXY=http://${proxy_addr}/" "NO_PROXY=localhost,127.0.0.1,docker.servicewall.cn"
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker

echo "docker daemon proxy is set to ${proxy_addr}"
