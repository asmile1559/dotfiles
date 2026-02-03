source $HOME/antigen.zsh

autoload -U compinit; compinit

# environments variables
export EDITOR=nvim

# aliases

# hooks
eval "$(starship init zsh)"
eval "$(direnv hook zsh)"
source <(fzf --zsh)

# plugins
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions

antigen use oh-my-zsh

antigen bundle git
antigen bundle aliases
antigen bundle sudo

antigen bundle direnv

antigen bundle Aloxaf/fzf-tab

antigen apply

