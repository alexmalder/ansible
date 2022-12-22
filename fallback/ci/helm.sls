---
{% set HELM_URL='https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3' %}

ci.helm-install:
  cmd.script:
    - name: masterscript
    - source: {{ HELM_URL }}
