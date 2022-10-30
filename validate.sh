#/bin/bash

set -eo pipefail

diff_prog="diff"

diff_not_origin() {
    find_path=$1
    sed_pattern=$2
    for file in $(find ${find_path} -type f); do
        sed_file=$(echo "$file" | sed "s/$sed_pattern//g")
        echo "$diff_prog $file $HOME/$sed_file"
        $diff_prog $file $HOME/$sed_file
    done
}

diff_by_path() {
    find_path=$1
    second_path=$2
    for file in $(find ${find_path} -type f); do
        echo "$diff_prog $file $second_path/$file"
        $diff_prog $file $second_path/$file
    done
}

main() {
    diff_by_path .config $HOME
    diff_not_origin home "home\/"
    diff_by_path etc
}

main
