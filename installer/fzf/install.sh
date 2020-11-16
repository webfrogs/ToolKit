#!/bin/bash
set -e

echo "[INFO] start to install fzf..."

case "$(uname -s)" in
  Darwin)
    brew install fzf
    $(brew --prefix)/opt/fzf/install --all
    ;;
  Linux)
    InstallationPath=$HOME/.fzf
    if test -d "${InstallationPath}"; then
      echo "[INFO] found fzf installation path, updating..."
      git fetch origin && git reset --hard origin/master
      ${InstallationPath}/install --all
      exit 0
    fi

    git clone --depth 1 https://github.com/junegunn/fzf.git ${InstallationPath}
    ${InstallationPath}/install --all
    ;;
  *)
    echo "[ERROR] Unsupported OS is found."
    exit 1
    ;;
esac

