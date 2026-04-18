# 补全样式：启用菜单选择模式（显示选中状态）
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# 补全增强 & 补全初始化
zi ice wait"0a" lucid atload"zicompinit; zicdreplay" blockf
zi light zsh-users/zsh-completions

# direnv
zi ice wait"0a" lucid as"program" make'!' atclone'./direnv hook zsh > zhook.zsh' \
    atpull'%atclone' pick"direnv" src"zhook.zsh"
zi light direnv/direnv

# git 补全
zi ice wait"0a" lucid as"completion"
zi snippet https://github.com/git/git/blob/master/contrib/completion/git-completion.zsh

# fzf 补全
zi ice wait"0d" lucid \
    atload'
        eval "$(fzf --zsh)"
    '
zi light Aloxaf/fzf-tab

# 历史记录插件
zi ice wait"0b" lucid \
    atload'
        eval "$(atuin init zsh)"
        bindkey "^R" _atuin_search_widget
    '
zi light atuinsh/atuin

# 自动建议
zi ice wait"0c" lucid \
    atload'
        _zsh_autosuggest_start
        # Ctrl+F: 有 autosuggestion 时接受，否则右移字符
        _autosuggest_or_forward_char() {
            if [[ -n "$POSTDISPLAY" ]]; then
                zle autosuggest-accept
            else
                zle forward-char
            fi
        }
        zle -N _autosuggest_or_forward_char
        bindkey "^F" _autosuggest_or_forward_char
    '
zi light zsh-users/zsh-autosuggestions

# 语法高亮
# zi ice wait"0e" lucid atinit"zpcompinit;zpcdreplay"
# zi light zdharma-continuum/fast-syntax-highlighting
