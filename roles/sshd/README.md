## SSHD

Install and setup sshd server

## Requirements

This role using default sshd centos server pacakge

## Role Variables

No role variables

## Dependencies

No role dependencies

## Example Playbook

```yaml
---
- name: Setup sshd without password login
  hosts: vm
  roles:
    - name: Use sshd role
      role: sshd
```

## TODO

- [ ] check nonroot user login

## Links

- [https://www.openssh.com/manual.html](https://www.openssh.com/manual.html)

## License

BSD

## Author Information

<vnmntn@mail.ru>
