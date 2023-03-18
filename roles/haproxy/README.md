## HAPROXY

Install and setup haproxy

## Requirements

This role using haproxy centos package

## Role Variables

Getted files from pass

- 'live/domain.com/fullchain.pem'
- 'live/domain.com/privkey.pem'
- 'live/dhparams.pem'

## Dependencies

No role dependencies

## Example Playbook

```yaml
- name: Setup haproxy
  gather_facts: false
  hosts: cloud0
  roles:
    - name: Use haproxy role
      role: haproxy
```

## Links

- [https://www.haproxy.com/documentation/](https://www.haproxy.com/documentation/)

## License

BSD

## Author Information

<vnmntn@mail.ru>
