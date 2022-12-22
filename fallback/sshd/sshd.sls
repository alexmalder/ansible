---
sshd:
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://sshd_config
  service.running:
    - enable: True
    - reload: True

systemctl restart sshd.service:
  cmd.run
