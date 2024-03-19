## Postgres

Install and setup PostgreSQL database role

## Requirements

This role using postgres alpine package

## Getted from pass

- `ansible/postgres.yml`

## Dependencies

No role dependencies

## Example Playbook

```yaml
- name: Install postgres
  hosts: cloud
  become: true
  roles:
    - postgres
```

## Links

- [postgres official site](https://postgresql.org)

## License

BSD

## Author Information

<vnmntn@mail.ru>
