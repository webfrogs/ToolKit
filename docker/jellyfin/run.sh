#!/bin/sh
set -e
set -o pipefail

cd $(dirname $0)

mkdir -p data
mkdir -p media/TVShows
mkdir -p media/Movies
renderId=$(getent group render | cut -d: -f3)

docker rm -f jellyfin || true
docker run -d --restart=always \
  --name=jellyfin \
  --net=host \
  -e TZ=Asia/Shanghai \
  -v $(pwd)/data/config/:/config/ \
  -v $(pwd)/data/cache:/cache/ \
  -v $(pwd)/media:/media/ \
  --group-add="${renderId}" \
  --device /dev/dri/renderD128:/dev/dri/renderD128 \
  jellyfin/jellyfin:latest
