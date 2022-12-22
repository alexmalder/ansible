{% for item in grains['fqdn_ip4'] %}

'echo {{ item }} is a ipv4 address, thanks':
  cmd.run

{% endfor %}
