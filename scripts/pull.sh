#!/bin/bash

set -eo pipefail

WORKDIR="../roles/init/files"

cp -rv ~/.config/negwm .config
cp -rv ~/.config/nvim .config
cp -rv ~/.config/kitty .config
cp -rv ~/.config/qutebrowser .config
cp -rv ~/.config/picom.conf .config
