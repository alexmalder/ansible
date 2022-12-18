FROM alpine:3.17

RUN apk update
RUN apk add ansible

WORKDIR /app

COPY . .

RUN ansible-playbook setup.yml
