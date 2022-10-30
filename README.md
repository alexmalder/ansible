# I3

My i3wm configuration center

## How to apply

`ansible-playbook .playbook.yml` 

## Top level in config

- `.config/nvim`
- `.config/negwm`
- `.config/qutebrowser`
- `.config/kitty`
- `.config/dunst`
- `.config/polybar`
- `.config/i3`
- `.config/zathura`
- `.config/picom`

## Top level in home
- `.clang-format`
- `.tmux.conf`
- `.xinitrc`
- `.zsh`
- `.zshrc`

## Undeclared templates

- `alsa.conf`
- `i3.jinja`
- `master`
- `Xresources`

## Undeclared configs and scripts

- `./bin`
- `./systemd`

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
        - ./vars/files.yml

    - name: install packages
      include_tasks: ./tasks/packages.yml

    - name: setup desktop environment
      include_tasks: ./tasks/desktop.yml
      vars:
        xft_dpi: 180

    - name: setup iptables
      include_tasks: ./tasks/iptables.yml

    - name: setup salt master
      include_tasks: ./tasks/salt.yml
```

## Links

- [ansible](https://www.ansible.com/)
- [i3](https://i3wm.org/)
- [polybar](https://polybar.github.io/)
- [alacritty](https://alacritty.org/)
- [picom](https://wiki.archlinux.org/title/Picom)
- [alsa](https://wiki.archlinux.org/title/Advanced_Linux_Sound_Architecture)
- [iptables](https://wiki.archlinux.org/title/Iptables)
