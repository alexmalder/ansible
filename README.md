# Ansible

## Roles and playbooks

- bitwarden: deploy vaultwarden service in docker
- gitlab-pull: used for gitlab pull all repos by project
- localhost: setup localhost packages, but configurations tasks in progress

## Scripts

- validate: dotfiles validator and puller

## Custom commands execution note

- `ansible hostname -m ansible.builtin.shell -a 'df -h /'`

> check custom command for hostname | ansible shell

## Authors

<vnmntn@mail.ru>
