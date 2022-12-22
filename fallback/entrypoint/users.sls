{% import_yaml 'vars/users.yml' as vars %}
{% for client in vars.users %}
{{ client.username }}:
  user.present:
    - fullname: {{ client.username }}
    - shell: /bin/bash
    - home: /home/{{ client.username }}
    - groups: {{ client.groups }}

/home/{{ client.username }}/.ssh:
  file.directory:
    - user: {{ client.username }}
    - mode: '0755'
    - makedirs: True

{% if client.pubkey is defined %}
deploy_public_key_for_{{ client.username }}:
  cmd.run:
    - name: echo {{ client.pubkey }} > /home/{{ client.username }}/.ssh/authorized_keys
{% endif %}

{% endfor %}
