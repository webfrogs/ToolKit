#!/bin/bash
set -e

proxy_addr=$1
if test -z "${proxy_addr}"; then
  proxy_addr="172.17.0.1:1090"
fi
echo "docker builder proxy address: ${proxy_addr}"

if test "$(docker buildx inspect mybuilder 2>/dev/null || echo $?)" = 1; then
  docker buildx create --name mybuilder \
    --driver-opt env.http_proxy=${proxy_addr} \
    --driver-opt env.https_proxy=${proxy_addr} \
    --driver-opt '"env.no_proxy=docker.servicewall.cn"' \
    --platform linux/amd64,linux/arm64 --use
  echo "docker builder with name 'mybuilder' is created"
else
  echo "docker builder with name 'mybuilder' exists."
fi
