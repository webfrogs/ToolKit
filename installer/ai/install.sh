#!/bin/sh
set -e
cd $(dirname $0)

if test $# -gt 0; then
  ARGS=$(getopt -o '' --long reinstall -n 'install.sh' -- "$@")
  if test $? != 0; then
    echo "ERROR! script options error"
    exit 1
  fi
  eval set -- "${ARGS}"
  while true; do
    case "$1" in
      --reinstall)
        OPT_REINSTALL="1"
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

if test "${OPT_REINSTALL}" == "1"; then
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

# agents skills
agents_skill_path="${HOME}/.agents/skills"
mkdir -p $(dirname ${agents_skill_path})
rm -rf ${agents_skill_path}
ln -sf $(pwd)/skills/agents ${agents_skill_path}

# agy skills
agy_skill_path="${HOME}/.gemini/config/skills"
mkdir -p $(dirname ${agy_skill_path})
rm -rf ${agy_skill_path}
ln -sf $(pwd)/skills/agents ${agy_skill_path}

echo "✅ AI tools installation completed successfully."
