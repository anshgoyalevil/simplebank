add_migrate:
	curl -L https://packagecloud.io/golang-migrate/migrate/gpgkey | sudo apt-key add - && echo "deb https://packagecloud.io/golang-migrate/migrate/ubuntu/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/migrate.list && sudo apt-get update && sudo apt-get install -y migrate 

add_sqlc:
	sudo snap add sqlc

postgres:
	docker run --name postgres17 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:17-alpine

createdb:
	docker exec -it postgres17 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres17 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

setup:
	make add_sqlc
	make add_migrate
	make postgres
	make createdb
	make migrateup

.PHONY: postgres createdb dropdb migrateup migratedown add_migrate add_sqlc