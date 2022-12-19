upgrade_cluster:
	ansible-playbook haproxy.yml
	ansible-playbook sshd.yml
	ansible-playbook debug-ip-addr.yml