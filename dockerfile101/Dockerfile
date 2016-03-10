FROM fedora:23
MAINTAINER Alexander Trost <galexrt@googlemail.com>

RUN dnf -q install -y nginx

ENTRYPOINT ["/usr/local/nginx", "-g", "daemon off;"]
