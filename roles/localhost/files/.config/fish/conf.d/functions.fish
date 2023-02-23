function fzfpass
    pass edit $(find $PASSWORD_STORE_DIR -type f -name '*.gpg' | sed 's/\.[^.]*$//' | sed "s/\/Users\/alexmalder\/Git\/store\///g" | fzf)
end

function url_to_md
    curl $argv[1] | pandoc -f html -t markdown > argv[2]
end

function wg_gen_keys
    wg genkey | tee /tmp/privatekey | wg pubkey | sudo tee /tmp/publickey
    echo "WIREGUARD PRIVATE KEY:"
    cat /tmp/privatekey
    echo "WIREGUARD PUBLIC KEY:"
    cat /tmp/publickey
end

function docker_image_clean
    docker images -a | grep none | awk '{ print $3; }' | xargs docker rmi --force
end

function helm_clone
    set name $argv[1]
    set chart $argv[2]
    echo "[$name $repo $chart] processing..."
    set versions $(helm search repo $name/$chart -l | awk '(NR>1)' | awk '{ print $2 }')

    for version in $versions
        helm pull $name/$chart --version $version -d charts
        echo "[version $version of chart $chart from repo $name pulled]"
    end
end
