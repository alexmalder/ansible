---
{% set DOCKER_CE='https://download.docker.com/linux/centos/docker-ce.repo' %}

ci.yum-utils:
  pkg.installed:
    - pkgs:
      - yum-utils

yum-config-manager --add-repo {{ DOCKER_CE }}:
  cmd.run

ci.docker-packages:
  pkg.installed:
    - pkgs:
      - docker-ce
      - docker-ce-cli
      - containerd.io

docker.service:
  service.running:
    - enable: True
    - reload: True
