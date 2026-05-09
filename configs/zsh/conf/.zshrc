[[ -f $HOME/.config/zsh/proxy.zsh ]] && source $HOME/.config/zsh/proxy.zsh
[[ -f $HOME/.config/zsh/preload.zsh ]] && source $HOME/.config/zsh/preload.zsh

eval "$(starship init zsh)"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# which: only search PATH, ignore functions/aliases
alias which='which -p'

# ls color settings
export CLICOLOR=1
if ls --color=auto &>/dev/null; then
  alias ls='ls --color=auto'
else
  alias ls='ls -G'
fi

#---- My config
export DEFAULT_USER=carl
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export TERM=xterm-256color

# ruby rvm settings (lazy load)
export PATH="$PATH:$HOME/.rvm/bin"
if [[ -s $HOME/.rvm/scripts/rvm ]]; then
    _rvm_load() {
        unfunction rvm ruby gem bundle 2>/dev/null
        source $HOME/.rvm/scripts/rvm
    }
    rvm()    { _rvm_load && rvm "$@" }
    ruby()   { _rvm_load && ruby "$@" }
    gem()    { _rvm_load && gem "$@" }
    bundle() { _rvm_load && bundle "$@" }
fi

# Golang settings
export GOPATH=$HOME/go

# Python settings
_python_path_load() {
    unfunction python3 pip3 2>/dev/null
    local user_base
    user_base="$(python3 -m site --user-base 2>/dev/null)"
    [[ -n "$user_base" ]] && export PATH="$PATH:${user_base}/bin"
}
python3() { _python_path_load && python3 "$@" }
pip3()    { _python_path_load && pip3 "$@" }

# Rust settings
export CARGO_NET_GIT_FETCH_WITH_CLI=true
export PATH="$PATH:$HOME/.cargo/bin" 
export RUSTUP_UPDATE_ROOT=https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup
export RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup

# Dev setting
export BXSHARE="/opt/bochs/share/bochs"
export PATH="/usr/local/bin:$PATH:/opt/bochs/bin:$HOME/.local/bin:$GOPATH/bin:/var/lib/snapd/snap/bin"
export THEOS=/opt/theos

# Homebrew env setting
if test -x "/home/linuxbrew/.linuxbrew/bin/brew"; then
  # linux homebrew
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" > /dev/null 2>&1
fi
if test -x "/opt/homebrew/bin/brew"; then
  # macOS homebrew
  eval "$(/opt/homebrew/bin/brew shellenv)" > /dev/null 2>&1
fi


# custom local setting
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# fzf settings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# nvm settings (lazy load)
export NVM_DIR="$HOME/.nvm"
if test -d "${NVM_DIR}"; then
    # Pre-inject the default nvm node version into PATH so that
    # `which node/npm/npx` works without triggering a full nvm load.
    # Use precmd hook to run after zi async plugins have finished modifying PATH.
    _nvm_inject_path() {
        local _nvm_default _nvm_bin
        _nvm_default="$(cat "$NVM_DIR/alias/default" 2>/dev/null)"
        # Resolve alias chain (e.g. default -> lts/* -> v20.x.x)
        while [[ -n "$_nvm_default" && -f "$NVM_DIR/alias/$_nvm_default" ]]; do
            _nvm_default="$(cat "$NVM_DIR/alias/$_nvm_default" 2>/dev/null)"
        done
        # Normalize: ensure version has leading 'v' to match directory name
        [[ "$_nvm_default" != v* ]] && _nvm_default="v${_nvm_default}"
        _nvm_bin="$NVM_DIR/versions/node/${_nvm_default}/bin"
        if [[ -d "$_nvm_bin" ]] && [[ ":$PATH:" != *":$_nvm_bin:"* ]]; then
            export PATH="$_nvm_bin:$PATH"
        fi
        # Only run once, then remove itself from precmd hooks
        add-zsh-hook -d precmd _nvm_inject_path
    }
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd _nvm_inject_path

    _nvm_load() {
        unfunction nvm node npm npx 2>/dev/null
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    }
    nvm() { _nvm_load && nvm "$@" }
    node() { _nvm_load && node "$@" }
    npm()  { _nvm_load && npm "$@" }
    npx()  { _nvm_load && npx "$@" }
fi

# gvm settings (lazy load)
if [[ -s "$HOME/.gvm/scripts/gvm" ]]; then
    _gvm_load() {
        unfunction gvm go gofmt 2>/dev/null
        source "$HOME/.gvm/scripts/gvm"
    }
    gvm()   { _gvm_load && gvm "$@" }
    go()    { _gvm_load && go "$@" }
    gofmt() { _gvm_load && gofmt "$@" }
fi


gh_pr() {
  BRANCH="$1"
  if test -z "$BRANCH"; then
    echo "[INFO] No branch found, using 'develop' as default"
    BRANCH="develop"
  fi

  repo_name="$(git remote -v | grep '(push)' | grep '^origin' | awk '{print $2}' | awk -F: '{print $NF}' | sed 's/.git$//g')"
  if test -z "$repo_name"; then
    echo "[ERROR] failed to get origin repository name."
    return 1
  fi

  current_branch="$(git rev-parse --abbrev-ref HEAD)"
  if test "${current_branch}" = "HEAD"; then
    echo "[ERROR] failed to find any git branch for HEAD."
    return 1
  fi

  git push -f webfrogs $current_branch
  GH_PR_URL="https://github.com/${repo_name}/compare/${BRANCH}...webfrogs:${current_branch}"
  if test -x "$(command -v xdg-open)"; then
    xdg-open "$GH_PR_URL"
  elif test -x "$(command -v open)"; then
    open "$GH_PR_URL"
  else
    echo "[ERROR] Can not open url automatically, copy url below to open it in browser."
    echo "$GH_PR_URL"
  fi
}

gh_clone() {
  GH_GIT_REPO="$1"
  if test -z "$GH_GIT_REPO"; then
    echo "[ERROR] No git repo."
    return 1
  fi
  if echo $GH_GIT_REPO | grep -qv '^git@'; then
    echo "[ERROR] git clone repo must start with 'git@'"
    return 1
  fi
  git clone $GH_GIT_REPO
  projectName=$(basename $GH_GIT_REPO | awk -F. '{print $1}')
  cd $projectName
  git remote add webfrogs $(echo $GH_GIT_REPO | sed 's#:.*/#:webfrogs/#')
  git fetch origin
  git submodule update --init --recursive
}

print_proxy_cmd() {
  proxy_addr="$1"
  if test -z "${proxy_addr}"; then
    proxy_addr="$(ip -o route get to 114.114.114.114 | sed -n 's/.*src \([0-9.]\+\).*/\1/p'):1090"
  fi
  if test -z "${proxy_addr}"; then
    proxy_addr="127.0.0.1:1090"
  fi
  echo "export http_proxy='http://${proxy_addr}' && export https_proxy='http://${proxy_addr}'"
}

# setup zoxide
eval "$(zoxide init zsh)"

# neovim terminal 兼容按键绑定
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^B" backward-char
bindkey "^N" down-line-or-history
bindkey "^P" up-line-or-history


# sdkman settings (lazy load)
export SDKMAN_DIR="$HOME/.sdkman"
_sdkman_load() {
  unfunction sdk java javac mvn gradle 2>/dev/null
  [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
  if ! sdk help &>/dev/null 2>&1; then
    curl -s "https://get.sdkman.io" | bash
    [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
  fi
}
sdk()    { _sdkman_load && sdk "$@" }
java()   { _sdkman_load && java "$@" }
javac()  { _sdkman_load && javac "$@" }
mvn()    { _sdkman_load && mvn "$@" }
gradle() { _sdkman_load && gradle "$@" }
