#!/bin/sh
set -e
set -o pipefail
cd $(dirname $0)

mkdir -p data/alist
mkdir -p data/local
uid=$(id -u)
gid=$(id -g)
mkdir -p data/alist/ssl
if test ! -f "data/alist/ssl/server.key"; then
  echo "init ssl cert..."
  openssl genrsa -out ./data/alist/ssl/server.key 2048
  openssl req -new -x509 -days 36500 -key ./data/alist/ssl/server.key \
		  -out ./data/alist/ssl/server.crt -subj \
			"/C=CN/ST=mykey/L=mykey/O=mykey/OU=mykey/CN=domain1/CN=domain2"
fi

tee docker-compose.yaml >/dev/null <<EOF
services:
  alist:
    image: 'xhofe/alist:latest'
    container_name: alist
    restart: always
    volumes:
      - ./data/alist:/opt/alist/data
      - ./data/local:/data/
    ports:
      - '5244:5244'
      - '5245:5245'
    environment:
      - TZ=Asia/Shanghai 
      - PUID=${uid}
      - PGID=${gid}
      - UMASK=022
EOF

docker image prune -f
docker compose up -d

