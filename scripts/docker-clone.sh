#!/bin/bash

docker_clone() {
  src=$1
  dest=$2
  docker pull $src
  docker tag $src $dest
  docker push $dest
}

DOCKER_REGISTRY="git.vnmntn.com/alexmalder"

docker_clone postgres:14 $DOCKER_REGISTRY/postgres:14-arm64
docker_clone python:3.8 $DOCKER_REGISTRY/python:3.8-arm64
docker_clone tarantool/tarantool:2 $DOCKER_REGISTRY/tarantool:2-arm64
docker_clone php:8.1-fpm $DOCKER_REGISTRY/php:8.1-fpm-arm64
