# Ansible

## Struct of directories

- `inventory`: inventory yaml configuration file
- `playbooks`: development automation
- `roles`: general roles storage
- `scripts`: main scripts
- `templates`: minimal templates for playbooks

## Pass integration for credmanager

- ansible.cfg
  - ./ansible.cfg
  - ~/.ssh/config
- inventory.yaml
  - ./inventory/inventory.yaml
- netrc.yml
  - ~/.netrc
  - ~/.config/fish/conf.d/netrc.fish
- hosts
  - /etc/hosts

## Help

`ansible hostname -m ansible.builtin.shell -a 'df -h /'`

## Authors

<vnmntn@mail.ru>
