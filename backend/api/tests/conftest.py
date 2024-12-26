import pytest

import os
from src import create_app
from src.extensions import db as _db
from sqlalchemy.orm import sessionmaker, scoped_session


def pytest_configure():
    os.environ["FLASK_ENV"] = "testing"
    os.environ["DATABASE_TEST_URL"] = os.environ.get(
        "DATABASE_TEST_URL", "postgresql://<user>:<password>@localhost:5432/homely_test"
    )
    os.environ["JWT_SECRET_KEY"] = os.environ.get(
        "JWT_SECRET_KEY", "testing-jwt-secret-key"
    )
    os.environ["HOMELY_SECRET"] = os.environ.get(
        "HOMELY_SECRET", "testing-homely-secret"
    )


@pytest.fixture(scope="session")
def app():
    """Create application for the tests."""
    app = create_app()
    ctx = app.app_context()
    ctx.push()

    yield app

    ctx.pop()


@pytest.fixture(scope="session")
def db(app):
    """Database fixture for the tests."""
    with app.app_context():
        _db.create_all()
        yield _db
        _db.session.remove()
        _db.drop_all()
        _db.engine.dispose()  # Close all connections


@pytest.fixture(scope="function")
def session(db):
    """Creates a new database session for each test."""
    connection = db.engine.connect()
    transaction = connection.begin()

    # Create new session for each test
    factory = sessionmaker(bind=connection)
    session = scoped_session(factory)

    old_session = db.session
    db.session = session

    yield session

    # Rollback changes after each test
    transaction.rollback()
    connection.close()
    session.remove()
    db.session = old_session


@pytest.fixture(scope="function")
def client(app):
    """Create a client for testing with a new session."""
    return app.test_client()


@pytest.fixture(autouse=True)
def cleanup(session):
    """Cleanup after each test."""
    yield
    session.rollback()
    session.close()
    session.remove()


@pytest.fixture()
def runner(app):
    """Create a CLI runner."""
    return app.test_cli_runner()
