---
auditbeat.install:
  pkg.installed:
    - name: auditbeat
    - enable: True
    - sources:
      - auditbeat: salt://auditbeat-8.2.2-x86_64.rpm

auditbeat.config:
  file.managed:
    - name: /etc/auditbeat/auditbeat.yml
    - source: salt://config/auditbeat.yml
    - show_changes: True

auditbeat.service:
  service.running:
    - enable: True
    - reload: True

sudo systemctl restart auditbeat:
  cmd.run
