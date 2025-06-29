## localhost

Install packages and configuration local system

## Requirements

- `pacman[archlinux]`

## Role Variables

No role variables in the current state

## Dependencies

No role dependencies

## Example Playbook

```yaml
- name: Setup system
  hosts: 127.0.0.1
  connection: local
  roles:
    - role: init
      vars:
        role_name: init
```

## TODO

- [ ] systemd services
- [ ] xorg configuration
- [ ] add tags in tasks

## Links

- [ansible](https://www.ansible.com/)
- [i3](https://i3wm.org/)
- [negwm](https://github.com/neg-serg/negwm)
- [polybar](https://polybar.github.io/)
- [kitty](https://github.com/kovidgoyal/kitty)
- [picom](https://wiki.archlinux.org/title/Picom)
- [alsa](https://wiki.archlinux.org/title/Advanced_Linux_Sound_Architecture)
- [iptables](https://wiki.archlinux.org/title/Iptables)

## License

BSD

## Author Information

<vnmntn@mail.ru>
