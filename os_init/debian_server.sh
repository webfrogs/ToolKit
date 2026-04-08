#!/bin/sh
set -e

cd $(dirname $0)
cd ..
RootPath=$(pwd)

if test $# -gt 0; then
  ARGS=$(getopt -o '' --long no-cn-mirror -n "$(basename "$0")" -- "$@")
  if test $? != 0; then
    echo "ERROR! $(basename "$0") options error"
    exit 1
  fi
  eval set -- "${ARGS}"
  while true; do
    case "$1" in
      --no-cn-mirror)
        OPT_NO_CN_MIRROR="1"
        shift
        ;;
      --)
        shift
        break
        ;;
      *)
        echo "ERROR! command options handle failed"
        exit 1
        ;;
    esac
  done
fi

if test "$(uname -s)" != "Linux"; then
  echo "[ERROR] Current OS is not Linux"
  exit 1
fi

if test ! -x "$(command -v apt)"; then
  echo "[ERROR] apt command is not found."
  exit 1
fi

sudo apt update

sudo apt install -y \
  vim \
  wireguard \
  make htop zsh

./configs/git/config.sh
./installer/fzf/install.sh
if test "${OPT_NO_CN_MIRROR}" = "1"; then
  ./installer/docker/install.sh
else
  ./installer/docker/install.sh --cn-mirror
fi
