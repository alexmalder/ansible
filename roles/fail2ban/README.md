## FAIL2BAN

Install and setup fail2ban.

## Requirements

- fail2ban centos package

## Role Variables

No role variables.

## Dependencies

No role dependencies.

## Example Playbook

```yaml
- name: Setup fail2ban
  hosts: selectel
  roles:
    - name: Use fail2ban role
      role: fail2ban
```

## TODO

- [ ] create variables

## License

BSD

## Author Information

<vnmntn@mail.ru>
