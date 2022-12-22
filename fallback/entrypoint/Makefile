iptables:
	pass env/ldap.sh | zsh | python ldap.py
	pass salt/wg.yml > vars/wg.yml
	salt wireguard state.apply iptables

wireguard:
	pass env/ldap.sh | zsh | python ldap.py
	pass salt/wg.yml > vars/wg.yml
	salt-ssh loopback state.apply wgclient
	salt wireguard state.apply wgserver
