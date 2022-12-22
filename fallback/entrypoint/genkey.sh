#!/bin/bash

set -eo pipefail

if [[ $1 == "" ]]; then
    echo "first argument must be not empty, thanks"
else
    mkdir -p keys/$1
    wg genkey | tee keys/$1/privatekey | wg pubkey > keys/$1/publickey
fi
