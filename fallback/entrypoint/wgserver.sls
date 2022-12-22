{% import_yaml 'vars/wg.yml' as vars %}
{% import_yaml 'vars/result.yml' as users %}
wireguard.setup:
  file.managed:
    - name: /etc/wireguard/wg0.conf
    - source: salt://config/wgserver.conf
    - template: jinja
    - defaults:
      vars: {{ vars }}
      users: {{ users }}

systemctl reload wg-quick@wg0:
  cmd.run
