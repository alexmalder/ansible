{% import_yaml 'vars/alertvars.yml' as vars %}

prometheus:
  user.present:
    - fullname: prometheus
    - shell: /bin/bash
    - groups:
      - wheel

/etc/prometheus:
  file.directory:
    - user: prometheus
    - group: prometheus
    - mode: '0755'
    - makedirs: True

/var/lib/prometheus:
  file.directory:
    - user: prometheus
    - group: prometheus
    - mode: '0755'
    - makedirs: True

{% if not salt['file.file_exists']('/usr/local/bin/prometheus') %}
prom.download:
  archive.extracted:
    - name: /tmp
    - source: "{{ vars.prom_url }}/v{{ vars.prom_version }}/prometheus-{{ vars.prom_version }}.linux-amd64.tar.gz"
    - user: prometheus
    - skip_verify: True
    - if_missing: /tmp/prometheus-{{ vars.prom_version }}.linux-amd64.tar.gz

prom.install:
  cmd.run:
    - name: |
        sudo cp /tmp/prometheus-{{ vars.prom_version }}.linux-amd64/prometheus /usr/local/bin
        sudo cp /tmp/prometheus-{{ vars.prom_version }}.linux-amd64/promtool /usr/local/bin
{% endif %}

prom.configure:
  file.managed:
    - name: /etc/prometheus/prometheus.yml
    - source: salt://config/prometheus_{{ grains['id'] }}.yml
    - user: prometheus

prom.fakehosts:
  file.managed:
    - name: /etc/hosts
    - source: salt://sys/hosts
    - user: prometheus

/etc/prometheus/rules:
  file.recurse:
    - source: salt://config/rules
    - user: prometheus
    - include_empty: True

/etc/systemd/system/prometheus.service:
  file.managed:
    - source: salt://config/template.service
    - template: jinja
    - defaults:
      exec: '/usr/local/bin/prometheus --config.file /etc/prometheus/prometheus.yml --storage.tsdb.path /var/lib/prometheus/'
      user: 'prometheus'

prometheus.service:
  service.running:
    - enable: True
    - reload: True

sudo systemctl restart prometheus:
  cmd.run
