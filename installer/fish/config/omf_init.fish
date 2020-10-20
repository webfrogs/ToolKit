set -xg GOPATH $HOME/go
set -xg PATH "$PATH:$HOME/.rvm/bin"

set -xg SDKMAN_DIR "$HOME/.sdkman"
#if test -e "$HOME/.sdkman/bin/sdkman-init.sh" 
#  source "$HOME/.sdkman/bin/sdkman-init.sh"
#end


# nvm settings
set -xg NVM_DIR "$HOME/.nvm"
#if test -e "$NVM_DIR/nvm.sh"
#  \. "$NVM_DIR/nvm.sh"
#end
