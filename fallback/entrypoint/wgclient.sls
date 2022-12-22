{% import_yaml 'vars/wg.yml' as vars %}

/home/alexmalder/wgtest:
  file.directory

{% for client in vars.wg_peers %}
{{ client.name }}:
  file.managed:
    - name: /home/alexmalder/wgtest/{{ client.name }}.conf
    - source: salt://config/wgclient.conf
    - template: jinja
    - defaults:
      vars: {{ client }}
{% endfor %}
