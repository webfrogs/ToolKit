#!/bin/sh
set -e

docker rm -f myfile || true
docker run -d --pull=always \
  --name=myfile \
  --restart=always \
  --log-opt max-size=10m \
  --log-opt max-file=1 \
  -p 443:443 \
  nswebfrog/myfile:latest
