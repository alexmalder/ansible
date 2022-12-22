---
#salt-minion.epel:
#  pkg.installed:
#    - pkgs:
#      - epel-release
#
#salt-minion.dependencies:
#  pkg.installed:
#    - pkgs:
#      - gcc
#      - python3-pip
#      - python3-devel

salt-minion.requirements:
  pip.installed:
    - name: salt

salt-minion.fix-violation:
  pip.installed:
    - name: typing-extensions

salt-minion.setup:
  file.managed:
    - name: /etc/systemd/system/salt-minion.service
    - source: salt://config/template.service
    - template: jinja
    - defaults:
      exec: '/usr/local/bin/salt-minion'
      user: 'root'

/etc/salt:
  file.directory:
    - mode: '0755'
    - makedirs: True

salt-minion.configure:
  file.managed:
    - name: /etc/salt/minion
    - source: salt://config/minion

salt-minion.service:
  service.running:
    - enable: True
    - reload: True
