# scripts

## saltprepare

First install for centos with salt

## audit

Extract dataflow actions by auditbeat logs, using clickhouse

## gitlab

### permissions

Extract gitlab permissions by all users

### pull

Script cloning and pulling gitlab repositories to workdir `$HOME/GItlab`.

### pipelines

Script deleting old pipelines

## wikiport

### environment variables

- `HOME`: default home for example
- `WIKI_HOST`: this is a host for graphql requests
- `WIKI_TOKEN`: jwt token

### config

```yaml
# config.yml
update_query: <graphql>
```

### how to run

`python3 ./main.py <path_to_config>`

this config structure:
```yaml
pages:
    - id: <int>
      title: <string>
      description: <string>
      path: <string>
```
