import pytest

import os
from src import create_app
from src.extensions import db as _db

def pytest_configure():
    os.environ['FLASK_ENV'] = 'testing'
    os.environ['DATABASE_TEST_URL'] = os.environ.get('DATABASE_TEST_URL', 'postgresql://<user>:<password>@localhost:5432/homely_test')
    os.environ['JWT_SECRET_KEY'] = os.environ.get('JWT_SECRET_KEY', 'testing-jwt-secret-key')
    os.environ['HOMELY_SECRET'] = os.environ.get('HOMELY_SECRET', 'testing-homely-secret')

@pytest.fixture(scope='session')
def app():
    app = create_app()

    with app.app_context():
        _db.create_all()
        yield app
        _db.drop_all()


@pytest.fixture(scope='session')
def client(app):
    return app.test_client()


@pytest.fixture(scope='session')
def db(app):
    return _db


@pytest.fixture(autouse=True)
def clear_database(db):
    db.session.remove()
    db.drop_all()
    db.create_all()


@pytest.fixture()
def runner(app):
    return app.test_cli_runner()
