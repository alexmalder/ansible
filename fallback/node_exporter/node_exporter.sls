---
{% set ne_version = '1.1.0' %}
{% set ne_uri = 'https://github.com/prometheus/node_exporter/releases/download' %}
node_exporter:
  user.present:
    - fullname: node_exporter
    - home: /var/lib/node_exporter

node_exporter.extract:
  archive.extracted:
    - name: /tmp
    - source: {{ ne_uri }}/v{{ ne_version }}/node_exporter-{{ ne_version }}.linux-amd64.tar.gz
    - user: node_exporter
    - group: node_exporter
    - if_missing: /tmp/node_exporter-{{ ne_version }}.linux-amd64
    - skip_verify: True
  cmd.run:
    - names:
      - sudo cp /tmp/node_exporter-{{ ne_version }}.linux-amd64/node_exporter /usr/local/bin/node_exporter

node_exporter.setup:
  file.managed:
    - name: /etc/systemd/system/node_exporter.service
    - source: salt://config/template.service
    - template: jinja
    - defaults:
      exec: '/usr/local/bin/node_exporter --web.listen-address=0.0.0.0:9100'
      user: 'node_exporter'

node_exporter.service:
  service.running:
    - enable: True
    - reload: True
