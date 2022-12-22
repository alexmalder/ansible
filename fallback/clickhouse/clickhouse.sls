{% import_yaml 'vars/clickvars.yml' as vars %}

clickhouse.dependencies:
  pkg.installed:
    - pkgs:
      - yum-utils

yum-config-manager --add-repo https://packages.clickhouse.com/rpm/clickhouse.repo:
  cmd.run

clickhouse.packages:
  pkg.installed:
    - pkgs:
      - clickhouse-server
      - clickhouse-client

clickhouse.config:
  file.managed:
    - name: /etc/clickhouse-server/config.xml
    - source: salt://config/config.xml
    - mode: '0600'
    - show_changes: True

clickhouse.users:
  file.managed:
    - name: /etc/clickhouse-server/users.xml
    - source: salt://config/users.xml
    - mode: '0600'
    - template: jinja
    - defaults:
      vars: {{ vars }}
    - show_changes: True

clickhouse-server.service:
  service.running:
    - enable: True
    - reload: True
