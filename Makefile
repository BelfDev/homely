# Makefile

# Default target to run docker-compose with the dev config
start: ## Start the application with docker-compose
	@docker compose -f docker-compose.dev.yml up --build

# A clean up command for stopping and removing containers
stop: ## Stop and remove all containers, networks, and volumes
	@docker compose -f docker-compose.dev.yml down

# Target for running tests
test: ## Run the test suite inside the Docker container
	@docker compose -f docker-compose.dev.yml run web poetry run pytest

# View logs for the web service
logs: ## Tail the logs from the web service
	@docker compose -f docker-compose.dev.yml logs -f web

# Target for linting with flake8
lint: ## Run the flake8 linter
	@docker compose -f docker-compose.dev.yml run web poetry run flake8 ./api

# Target to remove unused Docker images and containers
clean: ## Clean up dangling Docker containers and images
	@docker system prune -f

# Enter the PostgreSQL database container
enter-db: ## Open a psql shell to the database
	@docker exec -it homely-db-1 psql -U postgres -d homely

# Database migration command
db-migrate: ## Create new database migrations
	@docker compose exec web flask db migrate

# Apply database migrations
db-upgrade: ## Apply database migrations
	@docker compose exec web flask db upgrade

# Enter the web container shell
shell: ## Open an interactive shell inside the web container
	@docker exec -it homely-web-1 /bin/sh
	