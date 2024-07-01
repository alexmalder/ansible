#!/bin/bash
ansible-playbook gitlab-pull.yml -e GIT_URL=$GIT_URL_SECURE -e PRIVATE_TOKEN=$GIT_PASSWORD_SECURE -e group_id=2267
ansible-playbook credmanager.yml
ansible-playbook localhost.yml
