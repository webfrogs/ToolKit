#!/bin/bash
set -e

docker run --pull=always --rm --privileged multiarch/qemu-user-static --reset -p yes
echo "Done."
