---
{% set kafka_bootstrap_servers = '<kafka_ip_list>' %}
{% set kafka_bootstrap_servers_test = '<kafka_ip_test_list>' %}
{% set vector_elasticsearch_url = '<elastic_ip_with_http>' %}

vector:
  user.present:
    - fullname: vector

{% if not salt['file.file_exists']('/usr/bin/vector') %}
vector.install:
  pkg.installed:
    - name: vector
    - enable: True
    - sources:
      - auditbeat: salt://vector-0.24.0-1.x86_64.rpm
{% endif %}

vector.dependencies:
  pkg.installed:
    - pkgs:
      - vector

/etc/vector:
  file.directory:
    - user: vector
    - mode: '0640'
    - makedirs: True

vector.configure:
  file.managed:
    - name: /etc/vector/vector.yml
    - source: salt://config/{{ grains['id'] }}.yml
    - template: jinja
    - defaults:
      kafka_bootstrap_servers: {{ kafka_bootstrap_servers }}
      kafka_bootstrap_servers_test: {{ kafka_bootstrap_servers_test }}
      vector_elasticsearch_url: {{ vector_elasticsearch_url }}
    - show_changes: True

vector.setup:
  file.managed:
    - name: /usr/lib/systemd/system/vector.service
    - source: salt://config/template.service
    - template: jinja
    - defaults:
      exec: '/usr/bin/vector --config /etc/vector/vector.yml'
      user: 'root'

vector.service:
  service.running:
    - enable: True
    - reload: True

systemctl restart vector:
  cmd.run
