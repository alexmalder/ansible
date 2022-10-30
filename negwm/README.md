# NEGWM

Конфигурационные файлы `negwm` для персонального использования.

## Один из вариантов установки

1. Устанавливаем negwm

```
pip install git+https://github.com/neg-serg/negwm
```

2. Устанавливаем pm2

```
sudo npm i -g pm2
```

3. Запускаем negwm в режиме демона при помощи pm2

```
pm2 start "/usr/bin/env /usr/bin/python -c 'import negwm.main; negwm.main.run()'"
```

4. Проверяем работоспособность на примере запуска терминала

```
$mod+x
```

> если всё прошло удачно - видим запустившийся терминал на весь экран.

## Что здесь хранится

- `actions.cfg`
- `circle.cfg`
- `conf_gen.cfg`
- `executor.cfg`
- `fullscreen.cfg`
- `menu.cfg`
- `remember_focused.cfg`
- `scratchpad.cfg`

## План действий

- свести использование conf_gen к минимуму
- завести офисные приложения в circle

## Об авторе

- alexmalder: `vnmntn@mail.ru`
