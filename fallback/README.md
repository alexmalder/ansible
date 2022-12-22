# Salt

## Infrastructure general states

### Logging

- [clickhouse](./clickhouse) for logging
- [vector](./vector) for logging 
- [filebeat](./filebeat) for logging 

### Monitoring

- [prometheus](./promstack) for monitoring

### Inventory and access management

- [entrypoint](./entrypoint) is a inventory, wireguard and iptables center

### Quickstart

1. Clone salt repo to /srv/salt

```
git clone https://ci.dev.homeoperator.net/infrastructure/salt /srv/salt
```

2. Create systemd service

```
[Unit]
Description=salt-master
After=network.target
Documentation=man:salt-master

[Service]
Type=simple
User=alexmalder

Restart=always
RestartSec=3
ExecStart=salt-master -l debug
ExecReload=/bin/kill -HUP $MAINPID

TimeoutSec=300

[Install]
WantedBy=multi-user.target
```

3. Enable and start salt master

```
systemctl enable salt-master
systemctl start salt-master
```


### Configuration

```
# /etc/salt/master
#interface: 10.10.10.2
#ipv6: False
#publish_port: 4505
#user: root
#ret_port: 4506
#pidfile: /var/run/salt/salt-master.pid
#root_dir: /
#conf_file: /etc/salt/master
#pki_dir: /etc/salt/pki/master

file_roots:
  base:
    - /srv/salt/*
#   dev:
#     - /srv/salt/dev/services
#     - /srv/salt/dev/states
#   prod:
#     - /srv/salt/prod/services
#     - /srv/salt/prod/states
#
#file_roots:
#  base:
#    - /srv/salt

log_file: udp://127.0.0.1:10514
log_level: warning
```

### Links

- [https://saltproject.io/whats-saltstack/](https://saltproject.io/whats-saltstack/)
- [salt in 10 minutes](https://docs.saltproject.io/en/latest/topics/tutorials/walkthrough.html)
