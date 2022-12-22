---
docker-compose.prepare:
  pkg.installed:
    - pkgs:
      - openssl-devel
      - rust
      - cargo

docker-compose.setuptools:
  pip.installed:
    - name: setuptools-rust

docker-compose.install:
  pip.installed:
    - name: docker-compose
