# Prometheus Stack

## TOC

- [Сервисы](#сервисы)
- [Схема развертывания](#схема-развертывания)
- [Переменные окружения](#переменные-окружения)
  - [Публичные](#публичные)
  - [Приватные](#приватные)
- [Создание нового алерта](#создание-нового-алерта)
  - [Каналы](#каналы)
  - [Правила](#правила)
  - [Маршрутизация](#маршрутизация)
  - [Цели](#цели)
- [Существующая конфигурация](#существующая-конфигурация)
  - [Деплой](#деплой)
- [Об авторе](#об-авторе)

## Сервисы

- `prometheus`
- `grafana`
- `node_exporter`
- `alertmanager`
- `alertmanager_bot`

## Переменные окружения

### Публичные

- `prom_url`: https://github.com/prometheus/prometheus/releases/download
- `prom_version`: 2.8.1

- `blackbox_url`: https://github.com/prometheus/blackbox_exporter/releases/download
- `blackbox_version`: 0.14.0

- `alertmanager_url`: https://github.com/prometheus/alertmanager/releases/download
- `alertmanager_version`: 0.16.1

- `tg_author`: metalmatze
- `tg_repo`: alertmanager-bot
- `tg_branch`: master

### Приватные

```yaml
smtp_vars:
    SMTP_TO: ""
    SMTP_PASSWORD: ""
    SMTP_HOST: ""
    SMTP_PORT: ""
    SMTP_FROM: ""

tg_users_vars:
    TG_ADMIN_ID: ""
    TG_TOKEN: ""
    TG_LISTEN_ADDR: ""
    TG_SERVICE_NAME: ""

alertmanager_vars:
    TG_USERS_CHAT_ID: ""
    TG_USERS_LISTEN_PORT: ""
```

## Создание нового алерта

### Каналы

```yaml
# alertmanager.yml
receivers:
  # ...
  - name: "email"
    email_configs:
      - to: "{{ SMTP_TO }}"
        from: "{{ SMTP_FROM }}"
        smarthost: "{{ SMTP_HOST }}:{{ SMTP_PORT }}"
        auth_username: "{{ SMTP_FROM }}"
        auth_identity: "{{ SMTP_FROM }}"
        auth_password: "{{ SMTP_PASSWORD }}"
        require_tls: false
        send_resolved: true
# ...
```

### Правила

```yaml
# rules.yml
groups:
  - name: AllInstances
    rules:
      # ...
      - alert: DiskSpaceFree10Percent
        expr: node_filesystem_free_percent <= 10 # <<< EXPRESSION[PROMQL]
        labels:
          severity: warning # this is default label.
          # custom labels must be here
        annotations:
          summary: "Instance [{{ $labels.instance }}] has 10% or less Free disk space"
          description: "[{{ $labels.instance }}] has only {{ $value }}% or less free."
# ...
```

### Маршрутизация

```yaml
# alertmanager.yml
route:
  receiver: "admins"
  routes:
    # ...
    - match:
        severity: warning
      receiver: admins
# ...
```

### Цели

```yaml
# prometheus.yml
scrape_configs:
  # ...
  - job_name: "node_exporter"
    static_configs:
      - targets:
          - 127.0.0.1:8000
# ...
```

## Существующая конфигурация

### Деплой

Деплоится через `salt` следующей командой: 
`salt prometheus state.apply promstack`

Описание конфигурации

- `config/rules` хранит в себе правила алертов
- `config/templates` хранит в себе шаблон для уведомлений в телеграм через `alertmanager_bot`
- `grafana.ini` это стандартный графановский конфиг
- состояние графаны включает в себя конфигурацию `ldap.toml` для авторизации при помощи сервера `slapd`
  > в действительности это шаблон формата `jinja`, который требует словарь `ldap_vars` с перечисленными в нём ключами
- файл `prometаus_prometheus.yml` это конфиг для продового прометея и `prometheus_main-backup.yml` для офисного
  > офисный используется через федерацию

Описание состояний

- главное состояние - файл `promstack.sls`
- `promstack.sls` включает в себя состояния из директории `states`:
  - `states/prometheus`
  - `states/grafana`
  - `states/blackbox`
  - `states/alertmanager`
  - `states/alertmanager_bot`

Вспомогательные файлы

- `sys/grafana.repo` конфиг репозитория графаны под `centos`
- `sys/hosts` это список хостов для отобращения имени серверов в графане

Используемые экспортеры

- `node_exporter` - все сервера, и виртуальные и физические
- `ceph_exporter` - только железные сервера node1-node4 и node-test
- `blackbox_exporter` - мониторинг ключевых доменов, развернут там же,  где и прометей
- `cadvisor (docker exporter)` - dockerhost и slicing3
- `wireguard_exporter` - wireguard
- `mysql_exporter` - mysql-storage
- `rabbitmq_exporter` - rabbitmq
- `openldap_exporter` - openldap
- `redpanda_exporter (встроенный)` - redpanda{1,2,3}
- `rosreestr-msmo` - камтомный пром клиент, живет в офисе на pc-dev01

## Об авторе

`vnmntn@mail.ru`