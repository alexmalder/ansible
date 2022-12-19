upgrade_cluster:
	ansible-playbook haproxy.yml
	ansible-playbook debug-ip-addr.yml
	ansible-playbook sshd.yml
	ansible-playbook bind.yml
