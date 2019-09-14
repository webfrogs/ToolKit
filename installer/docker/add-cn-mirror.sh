#!/bin/bash
set -e

if [ ! `whoami` == "root" ]; then
    echo "Error! Shell should be executed by root."
    exit 1
fi

cat << EOF > /etc/docker/daemon.json
{
  "registry-mirrors": ["https://registry.docker-cn.com"]
}
EOF

systemctl restart docker.service