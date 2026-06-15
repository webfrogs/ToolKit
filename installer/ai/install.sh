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

if test "${OPT_SKIP_INSTALL}" != "1"; then
  sudo pacman -Syy
  # opencode
  paru -S --noconfirm opencode-bin
  # cc-switch
  paru -S --noconfirm cc-switch-bin
  # claude code
  paru -S --noconfirm claude-code-stable-bin
  # codex
  sudo pacman -S --noconfirm openai-codex
  # antigravity cli
  paru -S --noconfirm antigravity-cli
fi

