FROM archlinux

RUN pacman -Syyu --noconfirm
RUN pacman -S ansible ansible-lint --noconfirm

WORKDIR /app

COPY . .

RUN ansible-playbook init.yml
