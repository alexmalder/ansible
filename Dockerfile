FROM alpine:3.17

WORKDIR /app

RUN apk add npm git ansible ansible-lint
RUN ansible-galaxy collection install ansible.posix
RUN ansible-galaxy collection install community.general

COPY . .

RUN npm i -g markdownlint-cli
RUN find . | grep "\.md" | xargs -I % sh -c "markdownlint %"

RUN ansible-lint *.yml