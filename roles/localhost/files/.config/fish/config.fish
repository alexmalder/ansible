if status is-interactive

if not functions -q fundle; eval (curl -sfL https://git.io/fundle-install); end

#fundle plugin 'jorgebucaran/hydro'
#fundle plugin 'IlanCosman/tide@v6'
fundle plugin 'pure-fish/pure'
fundle plugin 'PatrickF1/fzf.fish'
fundle plugin 'justinmayer/virtualfish'

fundle init

alias vim="nvim"
alias :wq!="exit"
alias ff='vim $(fzf)'
alias gs="git status"
alias s="sudo"
alias python="python3.14"
alias ls="eza --git-ignore"

export VISUAL="nvim"
export EDITOR="nvim"
export NNN_OPENER="nvim"
export FZF_DEFAULT_OPTS="--color=bg+:-1,bg:-1,spinner:0,hl:51"
export FZF_DEFAULT_COMMAND="rg --files --hidden -g !.git"
export GOPATH="$HOME/.go"
export PATH="$PATH:$HOME/.go/bin"
export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.dotnet/tools"
export HELM_EXPERIMENTAL_OCI="1"
export DOTNET_ROOT=/opt/local/share/dotnet
export PASSWORD_STORE_DIR="$HOME/.store"
export LANG=en_US.UTF-8
# export TERM="tmux-256color"
# export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk17/Contents/Home"
# export PATH="$PATH:$HOME/.local/share/nvim/lsp_servers/jdtls/bin"

fish_config theme choose "Mono Smoke"

end
