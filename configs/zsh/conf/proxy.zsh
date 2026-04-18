# Proxy
alias proxy_all_set="export http_proxy='http://127.0.0.1:1091' && export https_proxy='http://127.0.0.1:1091' && export all_proxy='http://127.0.0.1:1091' && ftp_proxy='http://127.0.0.1:1091'"
alias proxy_all_unset="unset http_proxy && unset https_proxy && unset all_proxy && unset ftp_proxy"

alias proxy_unset="unset ALL_PROXY && unset http_proxy && unset https_proxy && unset ftp_proxy"

proxy_set() {
  proxy_addr="$1"
  if test -z "${proxy_addr}"; then
    proxy_addr="127.0.0.1:1090"
  fi
  export ALL_PROXY="socks5://${proxy_addr}"
  export http_proxy="http://${proxy_addr}"
  export https_proxy="http://${proxy_addr}"
  export ftp_proxy="http://${proxy_addr}"
  echo "proxy is set, address: ${proxy_addr}"
}
proxy_set

show_proxy_cmd () {
  hostIp=$(ip -o route get to 114.114.114.114 | sed -n 's/.*src \([0-9.]\+\).*/\1/p')
  echo "set proxy:"
  echo "export ALL_PROXY=socks5://${hostIp}:1090 && export http_proxy='http://${hostIp}:1090' && export https_proxy='http://${hostIp}:1090' && export ftp_proxy='http://${hostIp}:1090'"
  echo "unset proxy:"
  echo "unset ALL_PROXY && unset http_proxy && unset https_proxy && unset ftp_proxy"
}
