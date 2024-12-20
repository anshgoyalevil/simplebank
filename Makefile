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

migrateup1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up 1

migratedown1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down 1

sqlc:
	sqlc generate

setup:
	make postgres
	make createdb
	make migrateup

add:
	make add_migrate
	make add_sqlc

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/anshgoyalevil/simplebank/db/sqlc Store

.PHONY: postgres createdb dropdb migrateup migratedown migratedown1 migrateup1 add_migrate add_sqlc sqlc add setup test server mock