base:
	ansible-playbook ./playbooks/common.yml
	ansible-playbook ./sshd.yml
dns:
	ansible-playbook ./cluster-network.yml --tags dns
proxy:
	ansible-playbook ./cluster-network.yml --tags proxy

wireguard:
	mkdir -p ./roles/wireguard/vars
	pass config/wireguard.yml > ./roles/wireguard/vars/main.yml
	ansible-playbook ./wireguard.yml
