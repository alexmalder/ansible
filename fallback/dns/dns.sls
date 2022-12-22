{% import_yaml 'config/dnsvars.yml' as vars %}
named.dependencies:
  pkg.installed:
    - pkgs:
      - bind
      - bind-utils

named.config:
  file.managed:
    - name: /etc/named.conf
    - source: salt://config/named.conf
    - template: jinja
    - defaults:
      vars: {{ vars }}

named.forward:
  file.managed:
    - name: /var/named/{{ vars.DNS_DB }}.db
    - source: salt://config/example.db
    - template: jinja
    - defaults:
      vars: {{ vars }}

named.reverse:
  file.managed:
    - name: /var/named/{{ vars.DNS_DOMAIN }}.db
    - source: salt://config/domain.db
    - template: jinja
    - defaults:
      vars: {{ vars }}

named.service:
  service.running:
    - enable: True
    - reload: True

systemctl restart named:
  cmd.run

systemctl status named:
  cmd.run
