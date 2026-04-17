# copy from: https://github.com/jswysnemc/dotfiles/blob/main/zsh/.config/zsh/preload.zsh

# 定义zi 相关目录
typeset -Ag ZI
typeset -gx ZI[HOME_DIR]="${HOME}/.local/share/zi"
typeset -gx ZI[BIN_DIR]="${ZI[HOME_DIR]}/bin"

# 自动下载 zi 插件
if [ ! -f "${ZI[BIN_DIR]}/zi.zsh" ] ;
then
    command git clone https://github.com/z-shell/zi.git "$ZI[BIN_DIR]"
fi

# 加载zi 插件
source "${ZI[BIN_DIR]}/zi.zsh"

# 指定 补全缓存的路径
local zsh_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
zinit ice compinit-opts'-d "${zsh_cache_dir}/zcompdump"'

