-include src/.env

all: help

help:
	@echo "Usage:"
	@echo -e "\tmake up       - builds and runs containers"
	@echo -e "\tmake down     - stops containers"
	@echo -e "\tmake sh-nginx - starts a shell to the nginx container"
	@echo -e "\tmake sh-php   - starts a shell to the php container"
	@echo -e "\tmake sh-mysql - starts a shell to the mysql container"
	@echo -e "\tmake laravel  - initializes a new laravel project"

up:
	@if [ 'mysql' != '$(DB_HOST)' ]; then \
		echo "Changing DB_HOST value to 'mysql' ..."; \
		sed -i 's/DB_HOST=.*/DB_HOST=mysql/' src/.env; \
	fi

	@if [ '/var/www/html' != '$(XDG_CONFIG_HOME)' ]; then \
		echo "Appending XDG_CONFIG_HOME to .env ..."; \
		echo XDG_CONFIG_HOME=/var/www/html >> src/.env; \
	fi
	@echo "Prepairing the containers ..."
	@docker-compose --env-file src/.env up -d

down:
	@echo "Cleaning up the containers ..."
	@docker-compose --env-file src/.env down

sh-nginx:
	@echo "Starting a shell session to $(APP_NAME)_nginx ..."
	@docker exec -it $(APP_NAME)_nginx sh

sh-php:
	@echo "Starting a shell session to $(APP_NAME)_php ..."
	@docker exec -it -u 1000:1000 $(APP_NAME)_php sh

sh-php-root:
	@echo "Starting a root shell session to $(APP_NAME)_php ..."
	@docker exec -it $(APP_NAME)_php sh

sh-mysql:
	@echo "Starting a shell session to $(APP_NAME)_mysql ..."
	@docker exec -it $(APP_NAME)_mysql sh

laravel:
	@laravel new src
