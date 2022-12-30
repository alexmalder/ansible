## VECTOR

Install and setup vector log collector

## Requirements

This role using rpm install

## Role Variables

No role variables

## Dependencies

No role dependencies

## Example Playbook

```yaml
---
- name: Setup vector
  hosts: drone-runner
  roles:
    - name: Use vector role
      role: vector
```

## TODO

- [ ] test role in vm

## Links

- [https://vector.dev/docs/](https://vector.dev/docs/)

## License

BSD

## Author Information

<vnmntn@mail.ru>
