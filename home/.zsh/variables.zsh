# Setup terminal, and turn on colors
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad
export ARCHFLAGS='-arch x86_64'
export EDITOR='nvim'
export NNN_OPENER='nvim'
export QT_QPA_PLATFORMTHEME=qt5ct
export NVIM_PYTHON_LOG_FILE=/tmp/log
export NVIM_PYTHON_LOG_LEVEL=DEBUG
export FZF_DEFAULT_OPTS='--color=bg+:-1,bg:-1,spinner:0,hl:51'
export FZF_DEFAULT_COMMAND='rg --files --hidden -g !.git'
export PATH=$PATH:$HOME/go/bin
export TERM="screen-256color"
export LANG="en_US.UTF-8"
export GOPATH=$HOME/.go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export dt=`date '+%d-%m-%Y-%H-%M-%S'`
export VISUAL="nvim"
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
