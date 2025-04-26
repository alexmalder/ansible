#FROM almalinux:9
FROM alpine:3.18
#FROM archlinux

WORKDIR /app

#RUN dnf update -y && dnf install python-pip npm git -y && pip install ansible ansible-lint && npm i -g markdownlint-cli
RUN apk add npm git py3-pip gcc musl-dev python3-dev libffi-dev && pip install ansible ansible-lint && npm i -g markdownlint-cli
#RUN pacman -Syyu --noconfirm npm git python-pip ansible ansible-lint && npm i -g markdownlint-cli

COPY . .

RUN find . | grep "\.md" | xargs -I % sh -c "markdownlint %"

RUN ansible-lint ./xray.yml
RUN ansible-lint ./bitwarden.yml
RUN ansible-lint ./gitlab-pull.yml
RUN ansible-lint ./localhost.yml

#RUN ansible-playbook ./localhost.yml
