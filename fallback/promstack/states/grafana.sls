{% import_yaml 'vars/alertvars.yml' as vars %}

grafana-server.install:
  pkg.installed:
    - name: grafana
    - enable: True
    - sources:
      - grafana: salt://grafana-8.4.1-1.x86_64.rpm

grafana-server.setup-ldap:
  file.managed:
    - name: /etc/grafana/ldap.toml
    - source: salt://config/ldap.toml
    - user: root
    - group: grafana
    - template: jinja
    - defaults:
      ldap_vars: {{ vars.ldap_vars }}

grafana-server.service:
  service.running:
    - enable: True
    - reload: True
