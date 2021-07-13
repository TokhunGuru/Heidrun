export COMPOSE_PROJECT_NAME=heidrun
export COMPOSE_FILE=docker/docker-compose.yml

.DEFAULT_GOAL := up

.PHONY: up
up:
	$(MAKE) down
	docker-compose up -d
	$(MAKE) composer-install
	./docker/wait-for-mysql.sh
	$(MAKE) db-migrate

.PHONY: down
down:
	docker-compose down --remove-orphans

.PHONY: build
build:
	docker-compose build
	$(MAKE) up

#
# Helper functions
#

.PHONY: composer-install
composer-install:
	docker exec -it heidrun-web bash -c "cd application && composer install && composer dump-auto"

.PHONY: db-migrate
db-migrate:
	docker exec -it heidrun-web bash -c "cd application && php artisan migrate"

.PHONY: db-refresh
db-refresh:
	docker exec -it heidrun-web bash -c "cd application && php artisan migrate:fresh --seed"

.PHONY: admin-account
admin-account:
	docker exec -it heidrun-web bash -c "cd application && php artisan db:seed --class=AdminAccountSeeder"

.PHONY: status
status:
	docker-compose ps

.PHONY: logs
logs:
	docker-compose logs -f --tail=100

.PHONY: shell
shell:
	docker exec -it heidrun-web bash

.PHONY: stats
stats:
	docker stats heidrun-web heidrun-horizon heidrun-cron heidrun-mysql heidrun-redis

.PHONY: artisan
artisan:
	docker exec -it heidrun-web bash -c "cd application && php artisan $(COMMAND)"

.PHONY: self-signed-ssl
self-signed-ssl:
	cd ssl && openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout apache-cert.key -out apache-cert.crt
