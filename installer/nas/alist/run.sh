#!/bin/sh
set -e
set -o pipefail

cd $(dirname $0)

mkdir -p data
uid=$(id -u)
gid=$(id -g)

docker rm -f alist || true
docker run -d --restart=always \
  --name=alist \
  -p 5244:5244 \
  -e TZ=Asia/Shanghai \
  -e UMASK=022 \
  -e PUID=${uid} \
  -e PGID=${gid} \
  -v $(pwd)/data/:/opt/alist/data \
  xhofe/alist:latest


