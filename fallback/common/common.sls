---
common.cleaner:
  pkg.removed:
    - pkgs:
      - firewalld

common.epel:
  pkg.installed:
    - pkgs:
      - epel-release

common.packages:
  pkg.installed:
    - pkgs:
      - git
      - unzip
      - tar
      - yum-utils
      - ncdu
      - tmux

common.custom:
  pkg.installed:
    - pkgs:
      - python38-pip
      - htop
