# Clickhouse

Используется для сбора логов с кластера redpanda

### Поток данных

`FILE_OR_SERVICE <- VECTOR -> REDPANDA <- CLICKHOUSE -> REDASH`

### Особенности

- в качестве источника используется только redpanda
- логи собираются из топиков кластера redpanda
- в директории sql хранятся файлы со схемой таблиц и логикой сбора данных из топиков

### Дополнительная информация

- ретеншн не настроен
- особое внимание стоит уделить таблице `auditbeat_daily`, размер за сутки может превышать 10GB

### Ссылки

- [https://clickhouse.com/docs/en/engines/table-engines/integrations/kafka/](https://clickhouse.com/docs/en/engines/table-engines/integrations/kafka/)
