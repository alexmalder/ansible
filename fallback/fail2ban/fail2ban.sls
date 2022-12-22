---
fail2ban.dependencies:
  pkg.installed:
    - pkgs:
      - fail2ban

fail2ban.configure:
  file.managed:
    - name: /etc/fail2ban/jail.local
    - source: salt://config/jail.local

fail2ban.service:
  service.running:
    - enable: True
    - reload: True
