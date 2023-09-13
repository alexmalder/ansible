up:
	docker-compose up -d

down:
	docker-compose down
	docker volume rm example_data

connect:
	docker exec -it tarantool tarantoolctl connect tarantool:tarantool@127.0.0.1:3301

debug:
	docker-compose down
	docker volume rm example_data || exit 0
	docker-compose up -d
