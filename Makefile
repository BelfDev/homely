# Makefile

# Default target to run docker-compose with the dev config
start:
	@docker compose -f docker-compose.dev.yml up --build

# A clean up command for stopping and removing containers
stop:
	@docker compose -f docker-compose.dev.yml down

# Target for running tests
test:
	@docker compose -f docker-compose.dev.yml run web poetry run pytest

logs:
	@docker compose -f docker-compose.dev.yml logs -f web

# Target for linting with flake8
lint:
	@docker compose -f docker-compose.dev.yml run web poetry run flake8 ./api

# Target to remove unused Docker images and containers
clean:
	@docker system prune -f

enter-db:
	@docker exec -it homely-db-1 psql -U postgres -d homely
	