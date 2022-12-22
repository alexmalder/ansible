{% set sr_ver = '7.2' %}

rpm --import https://packages.confluent.io/rpm/{{ sr_ver }}/archive.key:
  cmd.run

/etc/yum.repos.d/confluent.repo:
  file.managed:
    - source: salt://templates/confluent-repo.j2
    - template: jinja
    - defaults:
      sr_ver: {{ sr_ver }}
    - show_changes: True

yum install confluent-schema-registry -y:
  cmd.run

/etc/schema-registry/schema-registry.properties:
  file.managed:
    - source: salt://templates/schema-registry.properties
    - template: jinja
    - defaults:
      sr_ver: {{ sr_ver }}
    - show_changes: True

confluent-schema-registry.service:
  service.running:
    - enable: True
    - reload: True


yum install confluent-control-center -y:
  cmd.run

/etc/confluent-control-center/control-center-production.properties:
  file.managed:
    - source: salt://templates/control-center-production.properties
    - show_changes: True

confluent-control-center.service:
  service.running:
    - enable: True
    - reload: True
