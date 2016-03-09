#!/bin/bash

docker stop mysql || true

docker rm mysql || true

docker run \
    --name mysql \
    -d \
    -e 'DB_NAME=wordpress' \
    -e 'DB_USER=wordpress' \
    -e 'DB_PASS=wordpress' \
    -v /opt/docker/database:/var/lib/mysql:rw \
    sameersbn/mysql:latest
