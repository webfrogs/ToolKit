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
  # gemini-cli
  sudo pacman -S --noconfirm gemini-cli
  # npm install -g @google/gemini-cli
  # cc-switch
  paru -S --noconfirm cc-switch-bin
  # claude code
  paru -S --noconfirm claude-code-stable-bin
  # codex
  sudo pacman -S --noconfirm openai-codex
fi


# gemini config
mkdir -p ~/.gemini
rm -f ~/.gemini/GEMINI.md
ln -sf $(pwd)/gemini/GEMINI.md ~/.gemini/GEMINI.md

# config proxy for cc-switch
sudo mkdir -p /opt/env/
sudo tee /opt/env/proxy_env >/dev/null <<EOF
http_proxy=http://127.0.0.1:1090
https_proxy=http://127.0.0.1:1090
no_proxy="localhost,127.0.0.1,192.168.1.0/24"
EOF
if test -e '/usr/share/applications/CC Switch.desktop'; then
  sudo sed -i '/^EnvironmentFile=/d' '/usr/share/applications/CC Switch.desktop'
  sudo sed -i '/^Exec=/a\EnvironmentFile=/opt/env/proxy_env' '/usr/share/applications/CC Switch.desktop'
fi
