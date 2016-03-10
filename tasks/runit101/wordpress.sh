#!/bin/bash

docker run \
    --name wordpress \
    -d \
    --link mysql:database \
    -p 8080:80 \
    -e 'WORDPRESS_DB_HOST=mysql:3306' \
    -e 'WORDPRESS_DB_NAME=wordpress' \
    -e 'WORDPRESS_DB_USER=wordpress' \
    -e 'WORDPRESS_DB_PASSWORD=wordpress' \
    -e 'WORDPRESS_AUTH_KEY=SECURE_AUTH_KEY' \
    -e 'WORDPRESS_LOGGED_IN_KEY=SECURE_LOGGED_IN_KEY' \
    -e 'WORDPRESS_AUTH_SALT=SECURE_AUTH_SALT' \
    -e 'WORDPRESS_LOGGED_IN_SALT=SECURE_LOGGED_IN_SALT' \
    wordpress
