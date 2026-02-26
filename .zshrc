source $HOME/antigen.zsh

autoload -U compinit; compinit

# environments variables
export EDITOR=nvim

# aliases


# plugins
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions

antigen use oh-my-zsh

antigen bundle git
antigen bundle aliases
antigen bundle sudo
antigen bundle command-not-found

antigen bundle direnv

antigen bundle Aloxaf/fzf-tab
antigen bundle voronkovich/gitignore.plugin.zsh
antigen apply

# Created by `pipx`
export PATH="$PATH:/home/box/.local/bin"

# hooks
eval "$(starship init zsh)"
eval "$(direnv hook zsh)"
source <(fzf --zsh)
eval "$(pixi completion --shell zsh)"

fpath+=~/.zfunc

source /usr/share/nvm/init-nvm.sh
