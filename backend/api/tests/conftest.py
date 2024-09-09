import pytest

from src import create_app
from src.config import TestConfig
from src.extensions import db as _db


@pytest.fixture(scope='session')
def app():
    app = create_app(config_object=TestConfig)

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
