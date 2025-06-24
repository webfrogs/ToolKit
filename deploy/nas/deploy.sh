#!/bin/sh
set -e
set -o pipefail

shellFolderPath=$(dirname $0)

mkdir -p photoprism
ln -sf ${shellFolderPath}/photoprism/run.sh photoprism/run.sh

mkdir -p jellyfin
ln -sf ${shellFolderPath}/jellyfin/run.sh jellyfin/run.sh
