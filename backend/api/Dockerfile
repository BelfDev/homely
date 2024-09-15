# syntax=docker/dockerfile:1.4

# Use the official Python base image
FROM python:3.12.3-slim-bullseye

# Install Poetry
RUN pip install poetry==1.8.3

# Set the environment variables for Poetry
ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    POETRY_CACHE_DIR=/root/.cache/pypoetry

# Set the working directory in the container
WORKDIR /app

# Copy the poetry.lock and pyproject.toml files to the container
COPY poetry.lock pyproject.toml /app/

# Copy the rest of the project files to the container
COPY src ./src
COPY tests ./tests
COPY README.md ./README.md
COPY gunicorn_config.py ./gunicorn_config.py
COPY .flake8 ./.flake8

# Use Docker's build cache for Poetry dependencies
# This line will cache the Poetry dependencies in a specific directory on the host during the build process.
# The POETRY_CACHE_DIR cache directory exists only during the build process (managed by the --mount=type=cache option).
RUN --mount=type=cache,target=$POETRY_CACHE_DIR \
    poetry install --with dev

# Expose the port on which the Flask app will run
EXPOSE 5000

# Add health check to ensure the container is running correctly
HEALTHCHECK CMD curl --fail http://localhost:5000/api/v1/health || exit 1

# Set the entrypoint command to run the Flask app
CMD ["poetry", "run", "gunicorn", "-c", "gunicorn_config.py", "src:create_app()"]
