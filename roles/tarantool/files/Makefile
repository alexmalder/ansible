up:
	docker-compose --env-file ./.env up -d

down:
	docker-compose down
	docker volume rm files_data

connect:
	docker exec -it tarantool tarantoolctl connect tarantool:tarantool@127.0.0.1:3301

json_to_yaml:
	cat krakend.json | yq -P > krakend.yaml

yaml_to_json:
	yq -o=json '.' krakend.yaml > krakend.json

debug:
	docker-compose stop tarantool
	docker-compose stop krakend
	docker volume rm files_data || exit 0
	docker-compose --env-file ./.env up -d tarantool
	docker-compose --env-file ./.env up -d krakend
	http get localhost:8082/api/v1/keycloak "Authorization: Bearer ${TOKEN}"

restart_tarantool:
	docker-compose down tarantool
	docker-compose down krakend
	docker volume prune --all --force
	docker-compose up --build -d
	ansible-playbook tests.yml -e keycloak_url=http://localhost:8080 -e krakend_url=http://localhost:8082 -e keycloak_admin_username=admin -e keycloak_admin_password=admin || exit 0
	sleep 2
	docker-compose logs tarantool
