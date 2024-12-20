#!/bin/bash
set -e

cd $(dirname $0)

if test -z "${HTTP_PROXY_ADDR}"; then
  if test -n "$1"; then
    HTTP_PROXY_ADDR="$1"
  else
    HTTP_PROXY_ADDR="127.0.0.1:1090"
  fi
fi
echo "==> proxy address: $HTTP_PROXY_ADDR"

IFS=":" read -ra proxy_info <<< "$HTTP_PROXY_ADDR"
if test "${#proxy_info[@]}" != "2"; then
  echo "env HTTP_PROXY_ADDR is invalid, whose value is '${HTTP_PROXY_ADDR}' "
  exit 2
fi

if test ! -e "${HOME}/.ssh/config"; then
  mkdir -p ${HOME}/.ssh
  touch ${HOME}/.ssh/config
fi

if test "$(grep -c '^Host github.com' ${HOME}/.ssh/config)" -ge 1; then
  echo "==> github proxy is already set."
  sed -i '/^Host github.com/,+5s#ProxyCommand socat.*$#ProxyCommand socat - PROXY:'${proxy_info[0]}':%h:%p,proxyport='${proxy_info[1]}'#' ${HOME}/.ssh/config
else
  echo "Host github.com" >> ${HOME}/.ssh/config
  echo "  HostName github.com" >> ${HOME}/.ssh/config
  echo "  User git" >> ${HOME}/.ssh/config
  echo "  ProxyCommand socat - PROXY:${proxy_info[0]}:%h:%p,proxyport=${proxy_info[1]}" >> ${HOME}/.ssh/config
fi

echo "github proxy is set."


