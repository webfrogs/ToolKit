#!/bin/sh
set -e

docker rm -f sftp || true
docker run --pull -d \
  --name=sftp \
  --restart=always \
  --log-opt max-size=10m \
  --log-opt max-file=1 \
  -p 6666:22 \
  nswebfrog/sftp:latest
