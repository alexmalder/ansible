#FROM almalinux:9
FROM alpine:3.18

WORKDIR /app

#RUN dnf update -y && dnf install python-pip npm git -y && pip install ansible ansible-lint && npm i -g markdownlint-cli

RUN apk add npm git py3-pip gcc musl-dev python3-dev libffi-dev && pip install ansible ansible-lint && npm i -g markdownlint-cli

COPY . .

RUN find . | grep "\.md" | xargs -I % sh -c "markdownlint %"

RUN ansible-lint *.yml
