# Ansible

## Systemd based roles

- libvirt
- wireguard
- haproxy

## OpenRC based roles

- fail2ban
- gitea
- postgres
- sshd

## Script-like based roles

- ci (kubectl, helm, docker, docker-compose)
- common (alpine only)
- localhost

## Script-like playbooks

- gitlab-pull
- validate (dotfiles)
- docker-clone
- git-remotes
- gitea-backup
- gitlab (docker)
- openldap (docker)

## TODO

- [ ] common role using with multi distributions
- [ ] postgres alpine setup

## Help

`ansible hostname -m ansible.builtin.shell -a 'df -h /'`

## Authors

<vnmntn@mail.ru>
