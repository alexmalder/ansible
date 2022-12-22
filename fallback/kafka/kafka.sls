{% set kafka_server_ip = '<kafka_ip>' %}
kafka:
  user.present:
    - fullname: kafka
  archive.extracted:
    - name: /tmp
    - source: https://dlcdn.apache.org/kafka/3.2.0/kafka_2.12-3.2.0.tgz
    - user: kafka
    - group: kafka
    - if_missing: /tmp/kafka_2.12-3.2.0
    - skip_verify: True
  cmd.run:
    - names:
      - sudo cp -r /tmp/kafka_2.12-3.2.0 /usr/local/kafka
      - sudo chown -R kafka /usr/local/kafka

kafka.setup:
  file.managed:
    - name: /usr/local/kafka/config/server.properties
    - source: salt://config/server.properties
    - user: kafka
    - group: kafka
    - template: jinja
    - defaults:
      kafka_server_ip: {{ kafka_server_ip }}
    - show_changes: True

zookeeper.service:
  file.managed:
    - name: /etc/systemd/system/zookeeper.service
    - source: salt://config/zookeeper.service
    - user: kafka
    - group: kafka

kafka.service:
  file.managed:
    - name: /etc/systemd/system/kafka.service
    - source: salt://config/kafka.service
    - user: kafka
    - group: kafka

/usr/local/bin/kafka_exporter:
  file.managed:
    - source: salt://bin/kafka_exporter

chmod +x /usr/local/bin/kafka_exporter:
  cmd.run

kafka_exporter.service:
  file.managed:
    - name: /etc/systemd/system/kafka_exporter.service
    - source: salt://config/kafka_exporter.service
    - show_changes: True
    - template: jinja
    - defaults:
      kafka_server_ip: {{ kafka_server_ip }}
  service.running:
    - enable: True
    - reload: True
