FROM alpine:3.17

WORKDIR /app

RUN apk add ansible
RUN ansible-galaxy collection install ansible.posix
RUN ansible-galaxy collection install community.general

COPY . .

RUN ansible-playbook ./playbook.yml
