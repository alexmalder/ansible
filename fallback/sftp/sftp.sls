{% set users = ['user1', 'user2', 'user3'] %}

sftponly:
  group:
    - present

{% for user in users %}
{{ user }}:
  user.present:
    - home: /storage/SFTP/{{ user }}
    - groups:
      - sftponly

#/storage/SFTP/{{ user }}:
#  file.directory:
#    - user: root
#    - group: root
#    - mode: '0755'
#    - makedirs: True

/storage/SFTP/{{ user }}/{{ user }}:
  file.directory:
    - user: {{ user }}
    - group: sftponly
    - mode: '0755'
    - makedirs: True
{% endfor %}

/usr/lib/systemd/system/sshd.service:
  file.managed:
    - source: salt://config/sshd.service
    - show_changes: True

sshd:
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://config/sftp_config
    #- template: jinja
    #- default:
    #  users: {{ users }}
    - show_changes: True
  service.running:
    - enable: True
    - reload: True

#systemctl restart sshd.service:
#  cmd.run
