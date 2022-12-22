{% import_yaml 'vars/result.yml' as clients %}
{% import_yaml 'vars/system.yml' as vars %}

{% for wg_peer in clients.wg_peers %}
{% if wg_peer.groups is defined %}
{% if wg_peer.allowed_ips is defined %}
{% if "backup" in wg_peer.groups %}

{% for host in vars.hosts %}

{% if host.hostname == "airflow" %}

{{ wg_peer.username }}-backup-in-setup:
  iptables.append:
    - table: filter
    - family: ipv4
    - chain: FORWARD
    - jump: ACCEPT
    - source: {{ wg_peer.allowed_ips }}
    - destination: {{ host.allowed_ips }}
    - dports:
        - 22
    - protocol: tcp
{{ wg_peer.username }}-backup-out-setup:
  iptables.append:
    - table: filter
    - family: ipv4
    - chain: FORWARD
    - jump: ACCEPT
    - source: {{ host.allowed_ips }}
    - destination: {{ wg_peer.allowed_ips }}
    - dports:
        - 22
    - protocol: tcp

{% endif %}

{% endfor %}

{% endif %}
{% endif %}
{% endif %}
{% endfor %}
