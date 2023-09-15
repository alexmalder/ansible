# Ansible

## Struct of directories

- `inventory`: inventory yaml configuration file
- `playbooks`: development automation
- `roles`: general roles storage
- `scripts`: main scripts
- `templates`: minimal templates for playbooks

## Local development

| service   | port |
| --------- | ---- |
| grafana   | 3000 |
| gitea     | 3030 |
| drone     | 8080 |
| keycloak  | 8081 |
| krakend   | 8082 |
| tarantool | 8090 |

## Help

`ansible hostname -m ansible.builtin.shell -a 'df -h /'`

## Authors

<vnmntn@mail.ru>
