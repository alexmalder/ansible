#/bin/bash

set -eo pipefail

diff_config() {
    for file in $(find .config -type f); do
        echo "colordiff $file $HOME/$file"
        colordiff $file $HOME/$file
    done
}

print_directories(){
    echo "Directories:"
    find .config -type d
}

main() {
    diff_config
    print_directories
}

main
