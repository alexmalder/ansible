up:
	docker-compose --env-file ./.env up -d

down:
	docker-compose down
	docker volume rm files_data

connect:
	docker exec -it tarantool tarantoolctl connect tarantool:tarantool@127.0.0.1:3301

debug:
	docker-compose stop tarantool
	docker-compose stop krakend
	docker volume rm files_data || exit 0
	docker-compose --env-file ./.env up -d tarantool
	docker-compose --env-file ./.env up -d krakend
