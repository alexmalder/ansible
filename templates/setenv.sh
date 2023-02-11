#!/bin/bash

set -eo pipefail

curl --request PUT --header "PRIVATE-TOKEN: {{priv_token}}" "{{glab_host}}/api/v4/groups/{{proj_id}}/variables/{{var_key}}" --form "value=$({{mycmd}})"
