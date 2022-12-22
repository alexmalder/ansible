{% import_yaml 'vars/system.yml' as system %}

ssh_config_new:
  file.managed:
    - name: /home/username/.ssh/config
    - source: salt://config/ssh_config.jinja
    - template: jinja
    - defaults:
      system: {{ system }}

salt-ssh.config:
  file.managed:
    - name: /etc/salt/roster
    - source: salt://config/roster.jinja
    - template: jinja
    - defaults:
      system: {{ system }}
