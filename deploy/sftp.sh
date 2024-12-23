#!/bin/sh
set -e

if test "$1" = "--pull"; then
  docker pull nswebfrog/sftp:latest
  exit
fi

docker rm -f sftp || true
docker run -d \
  --name=sftp \
  --restart=always \
  --log-opt max-size=10m \
  --log-opt max-file=1 \
  -p 6666:22 \
  nswebfrog/sftp:latest
