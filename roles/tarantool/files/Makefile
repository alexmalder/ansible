up:
	docker-compose --env-file ./.env up --build -d
	docker logs ansible-test -f

down:
	docker-compose down
	docker volume rm files_tarantool_data
	docker volume rm files_postgres_data

test_docker:
	docker-compose --env-file ./.env up --build -d
	docker logs ansible-test -f
	docker-compose down
	docker volume rm files_tarantool_data
	docker volume rm files_postgres_data

connect:
	docker exec -it tarantool tarantoolctl connect tarantool:tarantool@127.0.0.1:3301

json_to_yaml:
	cat krakend.json | yq -P > krakend.yaml

yaml_to_json:
	yq -o=json '.' krakend.yaml > krakend.json

debug:
	docker-compose stop tarantool
	docker-compose stop krakend
	docker volume rm files_tarantool_data || exit 0
	docker-compose --env-file ./.env up -d tarantool
	docker-compose --env-file ./.env up -d krakend

deploy_helm:
	helm install ingress-nginx nginx-stable/nginx-ingress --create-namespace --namespace ingress-nginx
	helm upgrade --install keycloak bitnami/keycloak -f ./helm/keycloak.values.yaml
	helm upgrade --install krakend equinixmetal/krakend -f ./helm/krakend.values.yaml
	#kubectl apply -f ./helm/tarantool.yaml
