#!/bin/bash

docker run \
    --name mysql \
    -d \
    -e 'DB_NAME=wordpress' \
    -e 'DB_USER=wordpress' \
    -e 'DB_PASS=wordpress' \
    sameersbn/mysql:latest
