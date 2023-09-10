up:
	docker-compose up -d

down:
	docker-compose down
	docker volume rm files_data

connect:
	docker exec -it tarantool tarantoolctl connect tarantool:tarantool@127.0.0.1:3301

recreate:
	docker-compose down
	docker volume rm files_data
	docker-compose up -d
