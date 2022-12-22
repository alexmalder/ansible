---
{% set gitlab_runner_script_url = 'https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh' %}

gitlab-runner.setup:
  cmd.script:
    - name: masterscript
    - source: {{ gitlab_runner_script_url }}

gitlab-runner.install:
  pkg.installed:
    - pkgs:
      - gitlab-runner
