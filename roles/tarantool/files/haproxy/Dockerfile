FROM haproxytech/haproxy-alpine:2.4
WORKDIR /etc/haproxy
COPY ./wildcard.pem .
COPY ./haproxy.cfg .
COPY ./dhparams.pem .
