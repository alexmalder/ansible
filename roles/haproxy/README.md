## HAPROXY

Install and setup haproxy

## Requirements

This role using haproxy centos package

## Role Variables

No role variables

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

## TODO

- [ ] add role variables

## Links

- [https://www.haproxy.com/documentation/](https://www.haproxy.com/documentation/)

## License

BSD

## Author Information

<vnmntn@mail.ru>
