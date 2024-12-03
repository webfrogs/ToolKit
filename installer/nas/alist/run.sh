#!/bin/sh
set -e
set -o pipefail
cd $(dirname $0)

mkdir -p data/alist
mkdir -p data/local/photos
uid=$(id -u)
gid=$(id -g)

mkdir -p data/nginx/ssl
if test ! -f "data/nginx/ssl/server.key"; then
  echo "init ssl cert..."
  openssl genrsa -out ./data/nginx/ssl/server.key 2048
  openssl req -new -x509 -days 36500 -key ./data/nginx/ssl/server.key \
		  -out ./data/nginx/ssl/server.crt -subj \
			"/C=CN/ST=mykey/L=mykey/O=mykey/OU=mykey/CN=domain1/CN=domain2"
fi
mkdir -p data/nginx/conf

tee data/nginx/conf/default.conf >/dev/null <<'EOF'
server {
    listen       443 ssl;
    server_name  _;

    gzip on;
    gzip_min_length 2k;
    gzip_types *;
    gzip_vary on;
    gzip_proxied any;
    add_header "Strict-Transport-Security" "max-age=60; includeSubDomains";

    ssl_certificate     /opt/alist/cert/server.crt;
    ssl_certificate_key /opt/alist/cert/server.key;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305;
    ssl_prefer_server_ciphers on;

    resolver 127.0.0.11 valid=10s;
    set $alist_server alist:5244;
    location / {
      client_max_body_size 500m;
      proxy_pass http://$alist_server;
      proxy_set_header Host $http_host;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      #proxy_pass_header Server;
      proxy_connect_timeout 10s;
      proxy_read_timeout 60s;
    }
}
EOF

tee data/nginx/Dockerfile >/dev/null <<'EOF'
FROM openresty/openresty:1.21.4.1-0-alpine 

ENV TZ=Asia/Shanghai
RUN set -e; \
  if test "$(cat /usr/local/openresty/nginx/conf/nginx.conf | grep -A 5 '^http' | grep -c 'more_set_headers')" == "0"; then \
    sed -i "/^http/a\ \ \ \ more_set_headers 'Server: ';" /usr/local/openresty/nginx/conf/nginx.conf; \
  fi; \ 
  if test "$(cat /usr/local/openresty/nginx/conf/nginx.conf | grep -A 5 '^http' | grep -c 'server_names_hash_bucket_size')" == "0"; then \
    sed -i "/^http/a\ \ \ \ server_names_hash_bucket_size 128;" /usr/local/openresty/nginx/conf/nginx.conf; \
  fi;  
COPY conf/default.conf /etc/nginx/conf.d/default.conf
COPY ssl/ /opt/alist/cert/
EOF


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
    environment:
      - TZ=Asia/Shanghai 
      - PUID=${uid}
      - PGID=${gid}
      - UMASK=022
  nginx:
    image: 'alist/nginx:latest'
    build: ./data/nginx
    container_name: nginx_alist
    restart: always
    ports:
      - 5245:443
EOF

docker compose build
docker image prune -f
docker compose up -d
