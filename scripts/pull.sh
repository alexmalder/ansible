#!/bin/bash

set -eo pipefail

WORKDIR="$HOME/git/ansible/roles/init/files"

cp -rv $HOME/.xinitrc $WORKDIR/home
cp -rv $XDG_CONFIG_HOME/negwm $WORKDIR/.config
cp -rv $XDG_CONFIG_HOME/nvim $WORKDIR/.config
cp -rv $XDG_CONFIG_HOME/kitty $WORKDIR/.config
cp -rv $XDG_CONFIG_HOME/qutebrowser $WORKDIR/.config
cp -rv $XDG_CONFIG_HOME/picom.conf $WORKDIR/.config
cp -rv $XDG_CONFIG_HOME/helm $WORKDIR/.config
