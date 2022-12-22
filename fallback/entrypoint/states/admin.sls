{% import_yaml 'vars/result.yml' as clients %}
{% import_yaml 'vars/system.yml' as vars %}

{% for wg_peer in clients.wg_peers %}
{% if wg_peer.groups is defined %}
{% if wg_peer.allowed_ips is defined %}

{% if "admin" in wg_peer.groups %}
{% for network in vars.networks %}

{{ wg_peer.username }}-{{ network }}-in-setup:
  iptables.append:
    - table: filter
    - chain: FORWARD
    - jump: ACCEPT
    - source: {{ wg_peer.allowed_ips }}
    - destination: {{ network }}

{{ wg_peer.username }}-{{ network }}-out-setup:
  iptables.append:
    - table: filter
    - chain: FORWARD
    - jump: ACCEPT
    - source: {{ network }}
    - destination: {{ wg_peer.allowed_ips }}

{% endfor %}
{% endif %}

{% endif %}
{% endif %}
{% endfor %}
