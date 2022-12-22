# MINION

## How to configure

Edit ip in ./config/minion.

## Rosterfile

```
# /etc/salt/roster
loopback:
    host: 127.0.0.1
    priv: /home/username/.ssh/id_ed25519
    port: 22
    user: root
    sudo: True
    priv_passwd: <passphrase>
```

Documentation: [https://docs.saltproject.io/en/latest/topics/ssh/roster.html](https://docs.saltproject.io/en/latest/topics/ssh/roster.html)

## Check this

`salt-ssh loopback test.ping`

## Run salt

`salt-ssh '*' state.apply minion`

Do not forget configure ./config/minion !
