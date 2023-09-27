FROM alpine:3.17

WORKDIR /app

RUN apk add ansible
RUN ansible-galaxy collection install ansible.posix
RUN ansible-galaxy collection install community.general

COPY . .

CMD ["ansible-playbook", "./playbook.yml", "-e", "keycloak_url=http://keycloak:8080/auth", "-e", "krakend_url=http://krakend:8082"]
