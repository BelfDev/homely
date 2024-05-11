# syntax=docker/dockerfile:1

# Use the official Python base image
FROM python:3.12.3-slim-bullseye

# Install Poetry
RUN pip install poetry==1.8.3

# Set the environment variables for Poetry
ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

# Set the working directory in the container
WORKDIR /app

# Copy the poetry.lock and pyproject.toml files to the container
COPY poetry.lock pyproject.toml /app/

# Copy the rest of the project files to the container
COPY api ./api
COPY README.md ./README.md

# Install project dependencies
RUN poetry install --without dev && rm -rf $POETRY_CACHE_DIR

# Expose the port on which the Flask app will run
EXPOSE 5000

# Set the entrypoint command to run the Flask app
CMD ["poetry", "run", "flask", "run", "--host=0.0.0.0"]
