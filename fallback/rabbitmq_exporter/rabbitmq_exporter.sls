---
rabbitmq_exporter:
  user.present:
    - fullname: rabbitmq_exporter

/etc/rabbitmq_exporter:
  file.directory:
    - user: rabbitmq_exporter
    - group: rabbitmq_exporter
    - mode: '0640'
    - makedirs: True

/usr/local/bin/rabbitmq_exporter:
  file.managed:
    - source: salt://rabbitmq_exporter

chmod +x /usr/local/bin/rabbitmq_exporter:
  cmd.run

rabbitmq_exporter.configure:
  file.managed:
    - name: /etc/rabbitmq_exporter/config.json
    - source: salt://vars/config.json
    - user: rabbitmq_exporter
    - group: rabbitmq_exporter

rabbitmq_exporter.setup:
  file.managed:
    - name: /etc/systemd/system/rabbitmq_exporter.service
    - source: salt://config/template.service
    - template: jinja
    - defaults:
      exec: '/usr/local/bin/rabbitmq_exporter -config-file /etc/rabbitmq_exporter/config.json'
      user: 'root'

rabbitmq_exporter.service:
  service.running:
    - enable: True
    - reload: True
