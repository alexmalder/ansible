base:
	ansible-playbook ./playbooks/common.yml
	ansible-playbook ./sshd.yml
dns:
	ansible-playbook ./cluster-network.yml --tags dns
proxy:
	ansible-playbook ./cluster-network.yml --tags proxy

wireguard:
	ansible-playbook ./wireguard.yml
