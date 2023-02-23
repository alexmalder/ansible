alias vim="nvim"
alias :wq!="exit"
alias ff='vim $(fzf)'
alias gs="git status"
alias vim="nvim"
alias ls="exa"
alias cl="clear"
alias s="sudo"

export PASSWORD_STORE_DIR="$HOME/Git/store"
export VISUAL="nvim"
export EDITOR="nvim"
export NNN_OPENER="nvim"
export FZF_DEFAULT_OPTS="--color=bg+:-1,bg:-1,spinner:0,hl:51"
export FZF_DEFAULT_COMMAND="rg --files --hidden -g !.git"
export GOPATH="$HOME/.go"
export PATH="$PATH:/opt/local/bin"
export PATH="$PATH:$HOME/.go/bin"
export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"
export PATH="$PATH:$HOME/Downloads/flutter/bin"
export PATH="$PATH:$HOME/Downloads/yandex-cloud/bin"

function fzfpass
    pass edit $(find $PASSWORD_STORE_DIR -type f -name '*.gpg' | sed 's/\.[^.]*$//' | sed "s/\/Users\/alexmalder\/Git\/store\///g" | fzf)
end

function url_to_md
    curl $argv[1] | pandoc -f html -t markdown > argv[2]
end

function wg_gen_keys
    wg genkey | tee /tmp/privatekey | wg pubkey | sudo tee /tmp/publickey
    echo "WIREGUARD PRIVATE KEY:"
    cat /tmp/privatekey
    echo "WIREGUARD PUBLIC KEY:"
    cat /tmp/publickey
end

function docker_image_clean
    docker images -a | grep none | awk '{ print $3; }' | xargs docker rmi --force
end
