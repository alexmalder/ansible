up:
	docker-compose up -d

down:
	docker-compose down
	docker volume rm files_data

connect:
	docker exec -it tarantool tarantoolctl connect tarantool:tarantool@127.0.0.1:3301

debug:
	docker-compose down
	docker volume rm files_data || exit 0
	docker-compose up -d
	http post http://127.0.0.1:8080/test
	docker logs tarantool
