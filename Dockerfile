FROM alpine:3.17

WORKDIR /app

COPY . .

RUN apk add npm
RUN npm i -g markdownlint-cli
RUN find . | grep "\.md" | xargs -I % sh -c "markdownlint %"

RUN apk add git ansible ansible-lint
RUN ansible-galaxy collection install ansible.posix
RUN ansible-galaxy collection install community.general
RUN ansible-lint *.yml
