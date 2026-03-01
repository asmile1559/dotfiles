#!/usr/bin/env zsh

eval "$(starship init zsh)"

eval "$(direnv hook zsh)"
source <(fzf --zsh)
eval "$(pixi completion --shell zsh)"
zsh-defer source /usr/share/nvm/init-nvm.sh
