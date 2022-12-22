{% import_yaml 'config/gitea.yml' as vars %}
# postgresql
postgresql:
  cmd.run:
    - names:
      - dnf module disable postgresql -y
      - dnf module enable postgresql:13 -y
      - dnf install postgresql postgresql-server -y
      - su - postgres -c 'postgresql-setup --initdb'

postgresql.base_config:
  file.managed:
    - name: /var/lib/pgsql/data/postgresql.conf
    - source: salt://config/postgresql.conf
    - user: postgres
    - group: postgres

postgresql.hba_config:
  file.managed:
    - name: /var/lib/pgsql/data/pg_hba.conf
    - source: salt://config/pg_hba.conf
    - user: postgres
    - group: postgres

postgresql.service:
  service.running:
    - enable: True
    - reload: True

# gitea
gitea:
  user.present:
    - fullname: gitea

gitea.stop:
  cmd.run:
    - names:
      - systemctl stop gitea

gitea.download:
  cmd.run:
    - names:
      - curl -o /tmp/gitea https://dl.gitea.io/gitea/1.16.9/gitea-1.16.9-linux-amd64
      - chmod +x /tmp/gitea
      - sudo cp /tmp/gitea /usr/local/bin/gitea
    - failhard: True

/etc/gitea:
  file.directory:
    - mode: '0750'
    - user: gitea
    - group: gitea
    - makedirs: True

/var/lib/gitea:
  file.directory:
    - mode: '0750'
    - user: gitea
    - group: gitea
    - makedirs: True

gitea.configure:
  file.managed:
    - name: /etc/gitea/app.ini
    - source: salt://config/app.ini
    - user: gitea
    - group: gitea
    - template: jinja
    - defaults:
      vars: {{ vars }}

gitea.service:
  file.managed:
    - name: /etc/systemd/system/gitea.service
    - source: salt://config/template.service
    - show_changes: True
    - template: jinja
    - defaults:
      exec: '/usr/local/bin/gitea web -c /etc/gitea/app.ini'
      user: 'gitea'
      vars: {{ vars }}
  service.running:
    - enable: True
    - reload: True
