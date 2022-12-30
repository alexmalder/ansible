## BIND

Install and setup bind dns server.

## Requirements

This role using bind and bind-utils centos packages.

## Role Variables

- `domain`: example.com
- `backward_zone_name`: 0.168.192.in-addr.arpa
- `listen_ip`: 192.168.122.16
- `allow_query`: 10.10.10.0/24

## Dependencies

No role dependencies.

## Example Playbook

```yaml
---
- name: Setup DNS
  hosts: selectel
  roles:
    - name: Use bind role
      role: bind
```

## TODO

- [ ] named-checkzone vnmntn.pro /var/named/vnmntn.pro.db
- [ ] named-checkzone 192.168.122.16 /var/named/vnmntn.pro.rev

## License

BSD

## Author Information

<vnmntn@mail.ru>
