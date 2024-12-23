#!/bin/sh
set -e

if test "$1" = "--pull"; then
  docker pull nswebfrog/myfile:latest
  exit
fi

docker rm -f myfile || true
docker run -d \
  --name=myfile \
  --restart=always \
  --log-opt max-size=10m \
  --log-opt max-file=1 \
  -p 6443:443 \
  nswebfrog/myfile:latest
