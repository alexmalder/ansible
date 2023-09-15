# Ansible

## Struct of directories

- `inventory`: inventory yaml configuration file
- `playbooks`: development automation
- `roles`: general roles storage
- `scripts`: main scripts
- `templates`: minimal templates for playbooks

## Local development

| service   | port | role      | deployment type |
| --------- | ---- | --------- | --------------- |
| haproxy   | 443  | haproxy   | docker          |
| grafana   | 3000 | loki      | systemd         |
| gitea     | 3030 | gitea     | systemd         |
| drone     | 8080 | ci        | docker          |
| keycloak  | 8081 | tarantool | docker          |
| krakend   | 8082 | tarantool | docker          |
| tarantool | 8090 | tarantool | docker          |

## Help

`ansible hostname -m ansible.builtin.shell -a 'df -h /'`

## Authors

<vnmntn@mail.ru>
