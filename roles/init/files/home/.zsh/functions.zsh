function git_prompt_info {
    local ref=$(=git symbolic-ref HEAD 2> /dev/null)
    local gitst="$(=git status 2> /dev/null)"
    if [[ -f .git/MERGE_HEAD ]]; then
        if [[ ${gitst} =~ "unmerged" ]]; then
            gitstatus=" %{$fg[lightgreen]%}unmerged%{$reset_color%}"
        else
            gitstatus=" %{$fg[magenta]%}merged%{$reset_color%}"
        fi
    elif [[ ${gitst} =~ "Changes to be committed" ]]; then
        gitstatus=" %{$fg[blue]%}!%{$reset_color%}"
    elif [[ ${gitst} =~ "use \"git add" ]]; then
        gitstatus=" %{$fg[lightgreen]%}!%{$reset_color%}"
    elif [[ -n `git checkout HEAD 2> /dev/null | grep ahead` ]]; then
        gitstatus=" %{$fg[yellow]%}*%{$reset_color%}"
    else
        gitstatus=''
    fi
    if [[ -n $ref ]]; then
        echo "%{$fg_bold[magenta]%}/${ref#refs/heads/}%{$reset_color%}$gitstatus"
    fi
}

function rationalise-dot {
    local MATCH
    if [[ $LBUFFER =~ '(^|/| |  |'$'\n''|\||;|&)\.\.$' ]]; then
        LBUFFER+=/
        zle self-insert
        zle self-insert
    else
        zle self-insert
    fi
}

function search {
    cd $(find . -type d -print | fzf)
}

function helm_upload {
    curl --insecure -v -F file=@$1 -u "$CHARTMUSEUM_USERNAME:$CHARTMUSEUM_PASSWORD" $CHARTMUSEUM
}

function url_to_md {
    curl $1 | pandoc -f html -t markdown > $2
}

function conn {
    ssh $(cat .ssh/config | grep "Host " | sed 's/Host\ //g' | fzf)
}
