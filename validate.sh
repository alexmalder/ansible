#/bin/bash

set -eo pipefail

compare_negwm() {
    for file in $(ls ./negwm); do
        colordiff ./negwm/$file ~/.config/negwm/$file
    done
}

compare_dunst(){
    colordiff ./config/dunst/dunstrc ~/.config/dunst/dunstrc
}

compare_kitty() {
    for file in $(ls ./config/kitty); do
        colordiff ./config/kitty/$file ~/.config/kitty/$file
    done
}

main() {
    compare_negwm
    compare_dunst
    compare_kitty
}

main
