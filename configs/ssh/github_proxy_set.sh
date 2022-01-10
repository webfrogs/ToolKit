#!/bin/sh
set -e

cd $(dirname $0)

if test -z "${HTTP_PROXY_ADDR}"; then
  echo "==> no env 'HTTP_PROXY_ADDR' found, using '127.0.0.1:1089' as default"
  HTTP_PROXY_ADDR="127.0.0.1:1089"
fi

IFS=":" read -ra proxy_info <<< "$HTTP_PROXY_ADDR"
if test "${#proxy_info[@]}" != "2"; then
  echo "env HTTP_PROXY_ADDR is invalid, whose value is '${HTTP_PROXY_ADDR}' "
  exit 2
fi

if test ! -e "${HOME}/.ssh/config"; then
  touch ${HOME}/.ssh/config
fi

if test "$(grep -c '^Host github.com' ${HOME}/.ssh/config)" -ge 1; then
  echo "==> github proxy is already set."
  exit
fi

echo "Host github.com" >> ${HOME}/.ssh/config
echo "  HostName github.com" >> ${HOME}/.ssh/config
echo "  User git" >> ${HOME}/.ssh/config
echo "  # 走 HTTP 代理" >> ${HOME}/.ssh/config
echo "  ProxyCommand socat - PROXY:${proxy_info[0]}:%h:%p,proxyport=${proxy_info[1]}" >> ${HOME}/.ssh/config

