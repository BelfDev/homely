# Makefile

# Get the web and db container names dynamically
web_container := $(shell docker compose -f docker-compose.yml ps -q web)
db_dev_container := $(shell docker compose -f docker-compose.yml ps -q db_dev)
db_test_container := $(shell docker compose -f docker-compose.yml ps -q db_test)

help: ## Display this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

# Default target to run docker-compose with the dev config
start: ## Start the application with docker-compose
	@docker compose -f docker-compose.yml up --build

# A clean up command for stopping and removing containers
stop: ## Stop and remove all containers, networks, and volumes
	@docker compose -f docker-compose.yml down --remove-orphans

# Target for running tests
test: ## Run the test suite inside the Docker container
	@docker compose -f docker-compose.yml run web poetry run pytest

# View logs for the web service
logs: ## Tail the logs from the web service
	@docker compose -f docker-compose.yml logs -f web

# Target for linting with flake8
lint: ## Run the flake8 linter
	@docker compose -f docker-compose.yml run web poetry run flake8 ./api

# Target to remove unused Docker images and containers
clean: ## Clean up dangling Docker containers and images
	@docker system prune -f --volumes

# Enter the PostgreSQL database container
enter-db: ## Open a psql shell to the database
	@docker exec -it $(db_dev_container) psql -U postgres -d homely

# Database migration command
db-migrate: ## Create new database migrations
	@docker compose exec web flask db migrate

# Apply database migrations
db-upgrade: ## Apply database migrations
	@docker compose exec web flask db upgrade

health: ## Check the health of the application
	@curl http://localhost:5050/api/v1/health

# Enter the web container shell
shell: ## Open an interactive shell inside the web container
	@docker exec -it $(web_container) /bin/sh
	