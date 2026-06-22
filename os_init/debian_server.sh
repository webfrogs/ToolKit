#!/bin/sh
set -e

cd $(dirname $0)

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

if test ! -r /etc/os-release; then
  echo "[ERROR] /etc/os-release is not found."
  exit 1
fi

. /etc/os-release
if test "${ID}" != "debian"; then
  echo "[ERROR] Current distribution is not Debian."
  exit 1
fi
if test -z "${VERSION_CODENAME}"; then
  echo "[ERROR] Debian VERSION_CODENAME is not found."
  exit 1
fi

if test ! -x "$(command -v apt)"; then
  echo "[ERROR] apt command is not found."
  exit 1
fi

if test "${OPT_NO_CN_MIRROR}" != "1"; then
  case "${VERSION_CODENAME}" in
    trixie | bookworm)
      sudo tee /etc/apt/sources.list.d/debian.sources >/dev/null <<EOF
Types: deb
URIs: https://mirrors.tuna.tsinghua.edu.cn/debian
Suites: ${VERSION_CODENAME} ${VERSION_CODENAME}-updates ${VERSION_CODENAME}-backports
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb
URIs: https://mirrors.tuna.tsinghua.edu.cn/debian-security
Suites: ${VERSION_CODENAME}-security
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
EOF
      ;;
    *)
      echo "[ERROR] Cannot configure Debian mirror for unsupported version codename: ${VERSION_CODENAME}"
      ;;
  esac
fi

sudo apt update
sudo apt upgrade

sudo apt install -y \
  vim \
  wireguard \
  net-tools dnsmasq tcpdump \
  bpftool \
  make htop zsh

sudo timedatectl set-timezone Asia/Shanghai

./configs/git/config.sh
./installer/fzf/install.sh
if test "${OPT_NO_CN_MIRROR}" = "1"; then
  ./installer/docker/install.sh
else
  ./installer/docker/install.sh --cn-mirror
fi
