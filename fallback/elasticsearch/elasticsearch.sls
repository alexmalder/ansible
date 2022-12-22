{% set elasticsearch_ip = '<elastic_ip>' %}

elasticsearch.dependencies:
  pkg.installed:
    - pkgs:
      - java-1.8.0-openjdk

elasticsearch.install:
  pkg.installed:
    - name: elasticsearch
    - enable: True
    - sources:
      - elasticsearch: salt://elasticsearch-6.8.10.rpm

elasticsearch.configure:
  file.managed:
    - name: /etc/elasticsearch/elasticsearch.yml
    - source: salt://config/elasticsearch.yml
    - mode: '0660'
    - user: root
    - group: elasticsearch
    - template: jinja
    - defaults:
      elasticsearch_ip: {{ elasticsearch_ip }}
    - show_changes: True

elasticsearch.configure-jvm:
  file.managed:
    - name: /etc/elasticsearch/jvm.options
    - source: salt://config/jvm.options
    - mode: '0660'
    - user: root
    - group: elasticsearch
    - show_changes: True

elasticsearch.service:
  service.running:
    - enable: True
    - reload: True

kibana.install:
  pkg.installed:
    - name: kibana
    - enable: True
    - sources:
      - kibana: salt://kibana-6.8.10-x86_64.rpm

kibana.configure:
  file.managed:
    - name: /etc/kibana/kibana.yml
    - source: salt://config/kibana.yml
    - mode: '0660'
    - user: kibana
    - group: elasticsearch
    - template: jinja
    - defaults:
      elasticsearch_ip: {{ elasticsearch_ip }}
    - show_changes: True

kibana.service:
  service.running:
    - enable: True
    - reload: True

systemctl restart elasticsearch:
  cmd.run
