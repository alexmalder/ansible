---
{% set WORKDIR = 'filebeat-8.4.2-linux-x86_64' %}
filebeat.extract:
  archive.extracted:
    - name: /etc
    - source: "salt://{{ WORKDIR }}.tar.gz"
    - if_missing: /etc/filebeat

filebeat.configure:
  file.managed:
    - name: /etc/{{ WORKDIR }}/filebeat.yml
    - source: salt://config/{{ grains['id'] }}.yml
    - user: root
    - show_changes: True

filebeat.setup-service:
  file.managed:
    - name: /etc/systemd/system/filebeat.service
    - source: salt://config/template.service
    - template: jinja
    - defaults:
      exec: /etc/{{ WORKDIR }}/filebeat
      user: root
      working_directory: /etc/{{ WORKDIR }}

filebeat.setup:
  cmd.run:
    - name: /etc/{{ WORKDIR }}/filebeat setup -e
    - cwd: /etc/{{ WORKDIR }}
    - stateful: True

filebeat.service:
  service.running:
    - enable: True
    - reload: True
