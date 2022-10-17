#  PLUGINS 
export XDG_CONFIG_HOME="$HOME/.config"
source "$XDG_CONFIG_HOME/zi/zi.zsh"

#  TMUX 
if ! xset q &>/dev/null; then
    echo "X server starting..."
    startx
else
    #tmux attach -t term || tmux new -s term > /dev/null
fi

zi load zsh-users/zsh-syntax-highlighting
zi light zsh-users/zsh-autosuggestions
zi light sunlei/zsh-ssh
zi light joshskidmore/zsh-fzf-history-search

source $HOME/.zsh/functions.zsh
source $HOME/.zsh/aliases.zsh
source $HOME/.zsh/bindkeys.zsh
source $HOME/.zsh/colors.zsh
source $HOME/.zsh/setopts.zsh
source $HOME/.zsh/ztyles.zsh
source $HOME/.zsh/variables.zsh

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

#scl enable gcc-toolset-10 zsh
