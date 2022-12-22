{% import_yaml 'vars/alertvars.yml' as vars %}

{{ vars.tg_users_vars.TG_SERVICE_NAME }}:
  user.present:
    - fullname: {{ vars.tg_users_vars.TG_SERVICE_NAME }}
    - shell: /bin/bash
    - groups:
      - wheel

{% if not salt['file.file_exists']('/usr/local/bin/alertmanager_bot') %}
{{ vars.tg_users_vars.TG_SERVICE_NAME }}.clone:
  git.latest:
    - name: https://github.com/{{ vars.tg_author }}/{{ vars.tg_repo }}.git
    - target: /tmp/{{ vars.tg_repo }}
    - user: {{ vars.TG_SERVICE_NAME }}
    - branch: {{ vars.tg_branch }}
    - require:
      - pkg: go

{{ vars.tg_users_vars.TG_SERVICE_NAME }}.install:
  cmd.run:
    - name: make build && cp /tmp/{{ vars.tg_repo }}/{{ vars.tg_repo }} /usr/local/bin
    - cwd: /tmp/{{ vars.tg_repo }}
{% endif %}

/tmp/templates:
  file.recurse:
    - source: salt://config/templates
    - include_empty: True

/etc/systemd/system/{{ vars.tg_users_vars.TG_SERVICE_NAME }}.service:
  file.managed:
    - source: salt://config/template.service
    - template: jinja
    - defaults:
      exec: |
        /usr/local/bin/alertmanager_bot \
        --telegram.admin={{ vars.tg_users_vars.TG_ADMIN_ID }} \
        --telegram.token={{ vars.tg_users_vars.TG_TOKEN }} \
        --store=bolt \
        --alertmanager.url=http://127.0.0.1:9093 \
        --listen.addr={{ vars.tg_users_vars.TG_LISTEN_ADDR }} \
        --bolt.path=/tmp/{{ vars.tg_users_vars.TG_SERVICE_NAME }}_bolt.db \
        --template.paths=/tmp/templates/default.tmpl
      user: root

{{ vars.tg_users_vars.TG_SERVICE_NAME }}.service:
  service.running:
    - enable: True
    - reload: True

systemctl restart {{ vars.tg_users_vars.TG_SERVICE_NAME }}:
    cmd.run
