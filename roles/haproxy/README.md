## HAPROXY

Install and setup haproxy

## Requirements

This role using haproxy centos package

## Role Variables

Getted from cli

- -e `workdir=haproxy`: workdir for
- -e `confdir=/etc`: config dir on remote server
- -e `owner=haproxy`: owner on remote server
- --tags `systemd`: `systemd|docker`

Getted files from pass

- `ansible/{{ workdir }}/haproxy.cfg`
- `ansible/{{ workdir }}/mycert.pem`
- `ansible/{{ workdir }}/dhparams.pem`

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
