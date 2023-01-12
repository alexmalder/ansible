## HAPROXY

Install and setup haproxy

## Requirements

This role using haproxy centos package

## Role Variables

Getted files from pass

- 'live/vnmntn.com/fullchain.pem'
- 'live/vnmntn.com/privkey.pem'
- 'live/dhparams.pem'

## Dependencies

No role dependencies

## Example Playbook

```yaml
- name: Setup haproxy
  hosts: selectel
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
