#!/bin/bash
set -e

# --- script options
OPT_PROXY="172.17.0.1:1090"
OPT_BUIDLER_NAME="mybuilder"

if test $# -gt 0; then
  ARGS=$(getopt -o '' --long proxy:,builder-name:,no-proxy -n 'create_builder.sh' -- "$@")
  if test $? != 0; then
    echo "ERROR! script options error"
    exit 1
  fi
  eval set -- "${ARGS}"
  while true; do
    case "$1" in
      --proxy)
        OPT_PROXY=$2
        shift 2
        ;;
      --builder-name)
        OPT_BUIDLER_NAME=$2
        shift 2
        ;;
      --no-proxy)
        OPT_NO_PROXY="1"
        shift
        ;;
      --)
        shift
        break
        ;;
      *)
        echo "internal error"
        exit 1
        ;;
    esac
  done
fi

PROXY_ADDR=""
if test "${OPT_NO_PROXY}" != "1"; then
  PROXY_ADDR="${OPT_PROXY}"
fi

echo "==> builder create info:"
printf "%-15s %-10s\n" proxy: ${PROXY_ADDR}
printf "%-15s %-10s\n" "builder-name:" ${OPT_BUIDLER_NAME}
echo ""

if test "$(docker buildx inspect ${OPT_BUIDLER_NAME} 2>/dev/null || echo $?)" = 1; then
  docker buildx create --name ${OPT_BUIDLER_NAME} \
    --driver-opt env.http_proxy=${PROXY_ADDR} \
    --driver-opt env.https_proxy=${PROXY_ADDR} \
    --driver-opt '"env.no_proxy=docker.servicewall.cn"' \
    --platform linux/amd64,linux/arm64 --use
  echo "docker builder with name '${OPT_BUIDLER_NAME}' is created"
else
  echo "docker builder with name '${OPT_BUIDLER_NAME}' exists."
fi
