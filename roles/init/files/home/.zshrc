#  PLUGINS 
export XDG_CONFIG_HOME="$HOME/.config"
source "$XDG_CONFIG_HOME/zi/zi.zsh"

zi load zsh-users/zsh-syntax-highlighting
zi light zsh-users/zsh-autosuggestions
zi load sunlei/zsh-ssh
zi light joshskidmore/zsh-fzf-history-search

source $XDG_CONFIG_HOME/zsh/functions.zsh
source $XDG_CONFIG_HOME/zsh/aliases.zsh
source $XDG_CONFIG_HOME/zsh/bindkeys.zsh
source $XDG_CONFIG_HOME/zsh/colors.zsh
source $XDG_CONFIG_HOME/zsh/setopts.zsh
source $XDG_CONFIG_HOME/zsh/ztyles.zsh
source $XDG_CONFIG_HOME/zsh/variables.zsh

zle -N rationalise-dot
bindkey . rationalise-dot

# COMPLETIONS 
autoload -Uz compinit && compinit
zmodload -i zsh/complist
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.zsh_history

PROMPT='%{$fg_bold[green]%}%~%<< $(git_prompt_info)%{$fg[magenta]%}>%{${reset_color}%} '

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
