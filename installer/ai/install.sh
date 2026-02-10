#!/bin/sh
set -e
cd $(dirname $0)

if test $# -gt 0; then
  ARGS=$(getopt -o '' --long skip-install -n 'install.sh' -- "$@")
  if test $? != 0; then
    echo "ERROR! script options error"
    exit 1
  fi
  eval set -- "${ARGS}"
  while true; do
    case "$1" in
      # --proxy)
      #   OPT_PROXY=$2
      #   shift 2
      #   ;;
      # --builder-name)
      #   OPT_BUIDLER_NAME=$2
      #   shift 2
      #   ;;
      --skip-install)
        OPT_SKIP_INSTALL="1"
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

# opencode
if test "${OPT_SKIP_INSTALL}" != "1"; then
  paru -S opencode-bin
  bunx oh-my-opencode install
fi

# gemini-cli
if test "${OPT_SKIP_INSTALL}" != "1"; then
  npm install -g @google/gemini-cli
  # gemini extensions install https://github.com/github/github-mcp-server
fi
mkdir -p ~/.gemini
rm -f ~/.gemini/GEMINI.md
ln -sf $(pwd)/gemini/GEMINI.md ~/.gemini/GEMINI.md

