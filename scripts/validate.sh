#/bin/bash

#set -eo pipefail

diff_prog="colordiff"

diff_func() {
    find_path=$1
    sed_pattern=$2
    for file in $(find ${find_path} -type f); do
        sed_file=$(echo "$file" | sed "s/$sed_pattern//g")
        #echo "$diff_prog $file $HOME/$sed_file"
        $diff_prog $file $HOME/$sed_file
    done
}

main() {
    diff_func roles/localhost/files/home "roles\/localhost\/files\/home\/"
    diff_func roles/localhost/files/.config "roles\/localhost\/files\/"
}

main
