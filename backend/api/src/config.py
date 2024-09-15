import os
from logging.config import dictConfig
from dotenv import load_dotenv

load_dotenv()


class Config(object):
    """Base configuration."""

    SECRET_KEY = os.environ.get("HOMELY_SECRET", "secret-key")
    APP_DIR = os.path.abspath(os.path.dirname(__file__))
    PROJECT_ROOT = os.path.abspath(os.path.join(APP_DIR, os.pardir))
    INSTANCE_DIR = os.path.join(PROJECT_ROOT, "instance")
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    JWT_SECRET_KEY = os.environ.get("JWT_SECRET_KEY", "jwt-secret-key")


class ProdConfig(Config):
    """Production configuration."""

    ENV = "prod"
    DEBUG = False
    SQLALCHEMY_DATABASE_URI = os.environ.get(
        "DATABASE_URL", "postgresql://localhost/example"
    )


class DevConfig(Config):
    """Development configuration."""

    ENV = "dev"
    DEBUG = True
    SQLALCHEMY_DATABASE_URI = os.environ.get(
        "DATABASE_URL", "postgresql://localhost/example"
    )


class TestConfig(Config):
    """Test configuration."""

    TESTING = True
    DEBUG = True
    SQLALCHEMY_DATABASE_URI = os.environ.get(
        "DATABASE_TEST_URL", "postgresql://localhost/example_test"
    )
    WTF_CSRF_ENABLED = False


dictConfig(
    {
        "version": 1,
        "formatters": {
            "default": {
                "format": "[%(asctime)s] %(levelname)s in %(module)s: %(message)s",
            }
        },
        "handlers": {
            "wsgi": {
                "class": "logging.StreamHandler",
                "stream": "ext://flask.logging.wsgi_errors_stream",
                "formatter": "default",
            }
        },
        "root": {"level": "INFO", "handlers": ["wsgi"]},
    }
)
