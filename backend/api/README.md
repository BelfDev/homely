# Running the App

## Pre-requisites

1. Python version 3.12.3 (I recommend you install it with pyenv)
2. Poetry installed
3. Virtual environment activated with `poetry shell`
4. `poetry install` in `homely/backend/api`

Assuming you are at this project's root directory:
```bash
flask run --debug
```
# Useful Commands

## Database

1. `flask db init` -> create a migration repository.
2. `flask db migrate -m "Initial migration."` -> generate an initial migration.
3. `flask db upgrade` -> apply the changes described by the migration script.

# Important notes

1. Don't forget to get the `.env` file with the main author!
