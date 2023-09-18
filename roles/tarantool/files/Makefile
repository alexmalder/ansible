up:
	docker-compose --env-file ./.env up -d
	ansible-playbook playbook.yml

down:
	docker-compose down
	docker volume rm tarantool_data
	docker volume rm postgres_data

connect:
	docker exec -it tarantool tarantoolctl connect tarantool:tarantool@127.0.0.1:3301

json_to_yaml:
	cat krakend.json | yq -P > krakend.yaml

yaml_to_json:
	yq -o=json '.' krakend.yaml > krakend.json

debug:
	docker-compose stop tarantool
	docker-compose stop krakend
	docker volume rm tarantool_data || exit 0
	docker-compose --env-file ./.env up -d tarantool
	docker-compose --env-file ./.env up -d krakend
	http get localhost:8082/api/v1/keycloak "Authorization: Bearer ${TOKEN}"
