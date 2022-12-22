{% import_yaml 'vars/alertvars.yml' as vars %}

blackbox:
  user.present:
    - fullname: blackbox
    - shell: /bin/bash
    - groups:
      - wheel

/etc/blackbox:
  file.directory:
    - user: blackbox
    - group: blackbox
    - mode: '0755'
    - makedirs: True

{% if not salt['file.file_exists']('/usr/local/bin/blackbox_exporter') %}
blackbox.download:
  archive.extracted:
    - name: /tmp
    - source: "{{ vars.blackbox_url }}/v{{ vars.blackbox_version }}/blackbox_exporter-{{ vars.blackbox_version }}.linux-amd64.tar.gz"
    - user: blackbox
    - group: blackbox
    - skip_verify: True
    - if_missing: /tmp/blackbox_exporter-{{ vars.blackbox_version }}.linux-amd64.tar.gz

blackbox.install:
  cmd.run:
    - name: cp /tmp/blackbox_exporter-{{ vars.blackbox_version }}.linux-amd64/blackbox_exporter /usr/local/bin
{% endif %}

blackbox.configure:
  file.managed:
    - name: /etc/blackbox/blackbox.yml
    - source: salt://config/blackbox.yml
    - makedirs: True

/etc/systemd/system/blackbox_exporter.service:
  file.managed:
    - source: salt://config/template.service
    - template: jinja
    - defaults:
      exec: '/usr/local/bin/blackbox_exporter --config.file=/etc/blackbox/blackbox.yml --web.listen-address=0.0.0.0:9115'
      user: 'blackbox'

blackbox_exporter.service:
  service.running:
    - enable: True
    - reload: True
