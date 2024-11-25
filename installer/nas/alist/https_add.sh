#!/bin/sh
set -e
set -o pipefail

if test ! -f "data/alist/config.json"; then
  echo "ERROR! alist config file is not found."
  exit 1
fi

if test ! -f "docker-compose.yaml"; then
  echo "ERROR! docker-compose.yaml is not found."
  exit 1
fi

sed -i 's/"https_port":.*$/"https_port": 5245,/g' data/alist/config.json
sed -i 's#"cert_file":.*$#"cert_file": "data/ssl/server.crt",#g' data/alist/config.json
sed -i 's#"key_file":.*$#"key_file": "data/ssl/server.key",#g' data/alist/config.json

docker compose up -d alist --force-recreate
