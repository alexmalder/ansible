## WIREGUARD

Install and setup wireguard vpn server

## Requirements

This role using wireguard centos package

## Role Variables

Getted from `pass`

```yaml
---
server:
  address: 10.10.10.1/24
  listen_port: 50100
  private_key: <server_private_key>
  peers:
    - name: username
      public_key: <client_public_key>
      allowed_ips: 10.10.10.2/32
client:
  props:
    public_key: <server_public_key>
    endpoint: <server_endpoint_with_port>
    persistent_keepalive: 25
    allowed_ips: 10.10.10.0/24
  clients:
    - name: username
      private_key: <client_private_key>
      address: 10.10.10.2/24
```

## Dependencies

No role dependencies

## Example Playbook

```yaml
---
- name: Setup wireguard server and generate wireguard client config files
  hosts: wireguard
  roles:
    - name: Use wireguard role
      role: wireguard
```

## Links

- [https://www.wireguard.com/](https://www.wireguard.com/)

## License

BSD

## Author Information

<vnmntn@mail.ru>
