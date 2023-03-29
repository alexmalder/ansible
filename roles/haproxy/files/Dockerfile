FROM haproxytech/haproxy-alpine:2.6
WORKDIR /etc/haproxy
COPY ./wildcard.pem .
COPY ./haproxy.cfg .
COPY ./dhparams.pem .
