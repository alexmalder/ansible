## Tarantool

Install and setup tarantool.

## Requirements

- this role using tarantool rpm package manually installation
- for local dev using docker-compose

## Role Variables

- `KEYCLOAK_HOSTNAME`: "localhost"

## Spaces

### Feed

```yaml
feed:
- name: id
  type: uuid
- name: title
  type: string
- name: link 
  type: string
- name: account_id
  type: uuid
```

### Label

```yaml
label:
- name: id
  type: uuid
- name: title
  type: string
- name: description
  type: string
```

### Feed-label relation

```yaml
feed_label:
- name: feed_id
  type: uuid
- name: label_id
  type: uuid
```

## Todo

- [how-to-print-a-formatted-string-in-lua](https://www.educative.io/answers/how-to-print-a-formatted-string-in-lua)
- [uuid-validation](https://www.tarantool.io/en/doc/latest/reference/reference_lua/uuid/#lua-function.uuid.is_uuid)

## License

BSD

## Author Information

<vnmntn@mail.ru>
