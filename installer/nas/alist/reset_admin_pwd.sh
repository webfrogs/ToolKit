#!/bin/sh
set -e
set -o pipefail

docker exec -it alist ./alist admin set 123456
