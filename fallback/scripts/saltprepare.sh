#!/bin/bash

set -eo pipefail

for node in vlabs_dev
do
    ssh-copy-id $node
    ssh $node "ip addr"
    ssh $node "yum remove firewalld -y"
    ssh $node "yum update -y"
    ssh $node "yum install python3-pip -y"
    ssh $node "pip3 install typing-extensions"
    ssh $node "yum install epel-release -y"
    ssh $node "yum install gcc python3-devel nmap net-tools vim zsh tmux -y"
    salt-ssh $node test.ping
    salt-ssh $node state.apply sshd
    salt-ssh $node state.apply minion
    salt-ssh $node state.apply node_exporter
done
