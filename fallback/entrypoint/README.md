# Точка входа в инфраструктуру

## Makefile

Makefile имеет две точки входа

- `make iptables` - применяет правила iptables с использованием pass и openldap

- `make wireguard` - создает на локальной машине клиентские конфиги и пушит серверный конфиг с использованием pass и openldap

## Инвентаризация

Список виртуальных машин хранится в базе ldap. Как создать файлы ~/.ssh/config и /etc/salt/roster

0. Создать директорию vars
1. Зайти в inventory.sls и поменять username на имя своего пользователя
2. Обеспечить доступ salt-minion на сервере openldap к серверу salt master
3. Запустить скрипт `pass env/ldap.sh | zsh | python ldap.py`
> Это создаст два конфига, а именно system.yml и result.yml (инфраструктура и пользователи)
4. Обеспечить работоспособность salt-ssh для loopback
5. Запустить состояние inventory.sls

```
salt-ssh loopback state.apply inventory
```

> Внимание! Это перезапишет файлы /etc/salt/roster и /home/username/.ssh/config

6. После чего можно ходить со своей локальной машины на сервера по конфигу /etc/salt/roster командами вида

```
salt-ssh <server_name> state.apply <state_name>
```

> Внимание! Такого рода действия требуют наличия конфига /etc/salt/master

## Файрвол

Правила файрвола применяются по группам, полученным из ldap

## Частная сеть wireguard

- информация о клиентах попадает из pass
- информация о сервере попадает из ldap

## Пользователи

- раскатка пользователей на сервера с их ключами ssh для удаленного доступа - не реализовано

## Скрипты

- `ldap.py` используется по следующей схеме:
    - `slapd` 
    - <- `salt.ldap3.search` 
    - -> `config.yml` 
    - <- `ldap.py` 
    - -> `[vars/result.yml,vars/system.yml]` 
    - <- `[iptables,wgserver]` 
    - -> `virtual servers`

## Схема аккаунта LDAP

Linux account manager:

- First name
- Last name
- Description: публичный ключ ssh
- Location: ip-адрес (если есть)
- Email address
- Web site: публичный ключ wireguard

## result.yml

```yaml
---
- allowed_ips: 10.10.10.2/32
  groups:
  - group1
  - group2
  - group3
  homeDirectory: /home/users/<username>
  loginShell: /bin/bash
  mail: <email>@<domain>
  public_key: <wireguard_pubkey>
  ssh_pubkey: <ssh_pubkey>
  username: <username>
```

## system.yml

```yaml
---
hosts:
- allowed_ips: 192.168.0.1
  groups:
  - vm-test
  hostname: vm-name
networks:
- 192.168.1.0/24
- 192.168.2.0/24
- 192.168.3.0/24
- 10.10.10.0/24
```

## wg.yml

```yaml
---
wg_server_address: 10.10.10.1/24
wg_server_port: <port>
wg_server_private_key: <server_private_key>
wg_peers:
  - name: username
    interface_private_key: <client_private_key>
    interface_address: 10.10.10.10/24
    peer_public_key: <server_public_key>
    peer_endpoint: <server_endpoint>
    peer_allowed_ips: <allowed_ips_for_client>
```
