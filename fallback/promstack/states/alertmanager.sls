{% import_yaml 'vars/alertvars.yml' as vars %}

alertmanager:
  user.present:
    - fullname: alertmanager
    - shell: /bin/bash
    - groups:
      - wheel

/etc/alertmanager:
  file.directory:
    - user: alertmanager
    - group: alertmanager
    - mode: '0755'
    - makedirs: True

{% if not salt['file.file_exists']('/usr/local/bin/alertmanager') %}
alertmanager.download:
  archive.extracted:
    - name: /tmp
    - source: "{{ vars.alertmanager_url }}/v{{ vars.alertmanager_version }}/alertmanager-{{ vars.alertmanager_version }}.linux-amd64.tar.gz"
    - user: alertmanager
    - group: alertmanager
    - skip_verify: True
    - if_missing: /tmp/alertmanager-{{ vars.alertmanager_version }}.linux-amd64.tar.gz

alertmanager.install:
  cmd.run:
    - name: |
        cp /tmp/alertmanager-{{ vars.alertmanager_version }}.linux-amd64/alertmanager /usr/local/bin
        cp /tmp/alertmanager-{{ vars.alertmanager_version }}.linux-amd64/amtool /usr/local/bin
{% endif %}

alertmanager.configure:
  file.managed:
    - name: /etc/alertmanager/alertmanager.yml
    - source: salt://config/alertmanager.yml
    - template: jinja
    - defaults:
      alertmanager_vars: {{ vars.alertmanager_vars }}
      smtp_vars: {{ vars.smtp_vars }}
    - show_changes: True

/etc/systemd/system/alertmanager.service:
  file.managed:
    - source: salt://config/template.service
    - template: jinja
    - defaults:
      exec: '/usr/local/bin/alertmanager --config.file /etc/alertmanager/alertmanager.yml'
      user: 'root'

alertmanager.service:
  service.running:
    - enable: True
    - reload: True

systemctl restart alertmanager:
  cmd.run
