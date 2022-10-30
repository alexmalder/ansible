# I3

My i3wm configuration center

## How to apply

`ansible-playbook .playbook.yml` 

## Configuration directories

```bash
# exa --tree -L 1 -a .config home etc .themes
.config
├── dunst
├── i3
├── kitty
├── negwm
├── nvim
├── picom.conf
├── polybar
├── qutebrowser
├── systemd
└── zathura
.themes
├── Material-Black-Cherry-4.0
└── README.md
etc
├── modprobe.d
├── salt
└── systemd
home
├── .clang-format
├── .tmux.conf
├── .xinitrc
├── .Xresources
├── .zsh
└── .zshrc
```

## Example playbook

```yaml
---
- name: i3 wm configuration
  hosts: 127.0.0.1
  gather_facts: false
  connection: local
  tasks:
    - name: use vars
      include_vars:
        file: "{{ item }}"
      with_items:
        - ./vars/packages.yml
        - ./vars/desktop.yml

    - name: install packages
      include_tasks: ./.ansible/packages.yml

    - name: setup desktop environment
      include_tasks: ./.ansible/desktop.yml
      vars:
        xft_dpi: 192

    - name: setup iptables
      include_tasks: ./.ansible/iptables.yml

    - name: setup salt master
      include_tasks: ./.ansible/salt.yml
```

## Links

- [ansible](https://www.ansible.com/)
- [i3](https://i3wm.org/)
- [negwm](https://github.com/neg-serg/negwm)
- [polybar](https://polybar.github.io/)
- [kitty](https://github.com/kovidgoyal/kitty)
- [picom](https://wiki.archlinux.org/title/Picom)
- [alsa](https://wiki.archlinux.org/title/Advanced_Linux_Sound_Architecture)
- [iptables](https://wiki.archlinux.org/title/Iptables)
