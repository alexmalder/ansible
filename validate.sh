#!/bin/bash

base_src=roles/localhost/files/.config
declare -a config_dirs
config_dirs[0]="fish/conf.d"
config_dirs[1]=nvim/lua

for directory in "${config_dirs[@]}"; 
do
  files=($(find ${base_src}/${directory} -type f))
  for file in "${files[@]}";
  do
    clean_path=$(echo $file | sed "s/.*config\///g")
    stored_path=${base_src}/${clean_path}
    origin_path="${HOME}/.config/${clean_path}"
    echo "diff --color ${origin_path} ${stored_path}"
    diff --color ${origin_path} ${stored_path}
    if [[ $? -ne 0 ]]; then
        echo "Must be root to run script"
        cp ${origin_path} ${stored_path}
        #exit
    fi

    #echo $status
  done
done
