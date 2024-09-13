# Running the App

## Pre-requisites

1. **Docker** and **Docker Compose** installed on your machine.
2. Obtain the `.env` file from the project owner (see below).
3. **Make** installed to use provided commands for quick setup.

## Steps for running Homely API locally

Assuming you are at the root of the project directory:

### 1) **Get the .env file**  
   Ensure you get the `.env` file from the main author before proceeding. This file contains essential environment variables.

   Example `.env`:
   ```bash
   FLASK_APP=src
   JWT_SECRET_KEY=something-1
   HOMELY_SECRET=something-2
   DATABASE_URL=something-3
   POSTGRES_USER=something-4
   POSTGRES_PASSWORD=something-5
   POSTGRES_DB=something-6
   ```

### 2) Start the application via docker compose

To spin up the app and start developing, run the following:

```bash
make start
```

### 3) Access the healthcheck endpoint

You can access the API on http://localhost:5050/api/v1/health after running make start. Alternatively, you can run the command below.

```bash
curl http://localhost:5050/api/v1/health
```

This will send a GET request to the health check endpoint, and if everything is running correctly, you should receive a JSON response like:

```json
{"status": "ok"}
```


## Development Workflow

### Make code changes

Assuming you have Homely API running via docker compose, any changes made to the code inside the src directory will be reflected automatically in the running Flask app, as the source code is mounted to the Docker container for live updates.

### Run tests

To run tests within the container:

```bash
make test
```

### Stop the app

To stop the running containers:

```bash
make stop
```

### Clean up resources

To remove all containers, networks, and volumes related to the app:

```bash
make clean
```

## Database

### Database migrations

1.	`flask db init` → Create a migration repository.
2.	`flask db migrate -m "Initial migration."` → Generate an initial migration.
3.	`flask db upgrade` → Apply the changes described by the migration script.


These commands can be run from inside the container as follows:
```bash
docker-compose exec web flask db <command>
```

There a few convinience aliases available:

- `make db-migrate` → Generates a new database migration based on model changes.
- `make db-upgrade` → Applies the database migrations to sync the database schema.
- `make enter-db` → Opens an interactive psql shell for the homely PostgreSQL database inside the container.
- `make logs` → View real-time logs from the Docker containers.

# Useful 3rd-party docs

1.[Flask SQLAlchemy](https://flask-sqlalchemy.palletsprojects.com/en/3.1.x/quickstart/)
2.[Flask-Migrate](https://flask-migrate.readthedocs.io/en/latest/)
