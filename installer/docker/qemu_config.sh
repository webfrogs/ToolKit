#!/bin/bash
set -e

docker run --pull --rm --privileged multiarch/qemu-user-static --reset -p yes
echo "Done."
