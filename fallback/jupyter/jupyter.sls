---
jupyter:
  user.present:
    - fullname: jupyter
    - shell: /bin/bash
    - home: /home/jupyter

jupyter.install:
  pip.installed:
    - name: jupyter

/home/jupyter/notebooks:
  file.directory:
    - user: jupyter
    - group: jupyter
    - mode: '0755'
    - makedirs: True

jupyter.configure:
  file.managed:
    - name: /home/jupyter/.jupyter/jupyter_notebook_config.py
    - source: salt://config/jupyter_notebook_config.py

jupyter-notebook.service:
  file.managed:
    - name: /etc/systemd/system/jupyter-notebook.service
    - source: salt://config/jupyter-notebook.service
  service.running:
    - enable: True
    - reload: True
