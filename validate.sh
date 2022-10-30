#/bin/bash

set -eo pipefail

diff_config() {
    for file in $(find .config -type f); do
        echo "colordiff $file $HOME/$file"
        colordiff $file $HOME/$file
    done
}

diff_home() {
    for file in $(find home -type f); do
        sed_file=$(echo "$file" | sed 's/home\///g')
        echo "colordiff $file $HOME/$sed_file"
        colordiff $file $HOME/$sed_file
    done
}

main() {
    diff_config
    diff_home
}

main