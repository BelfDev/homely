import os

from flask import Flask, jsonify

from src.config import DevConfig, ProdConfig, TestConfig
from src.extensions import db, db_init_app, cors, jwt, marsh, swagger_ui
from src.user import user_blueprint
from src.task import task_blueprint
from src.common import user_identity_lookup, user_lookup_callback


def get_config():
    """Helper function to select the appropriate configuration class based on FLASK_ENV."""
    env = os.environ.get("FLASK_ENV", "development")
    if env == "production":
        return ProdConfig
    elif env == "testing":
        return TestConfig
    else:
        return DevConfig


def create_app():
    config_object = get_config()

    # create and configure the app
    app = Flask(
        __name__,
        instance_relative_config=True,
        instance_path=config_object.INSTANCE_DIR,
    )
    app.config.from_object(config_object)
    create_instance_dir(app)
    register_extensions(app)
    register_routes(app)

    @app.route("/api/v1/health", methods=["GET"])
    def healthcheck():
        return jsonify({"status": "ok"}), 200

    return app


def register_extensions(app):
    db_init_app(app)
    jwt.init_app(app)
    swagger_ui.init_app(app)


def register_routes(app):
    origins = app.config.get("CORS_ORIGIN_WHITELIST", "*")
    cors.init_app(app, origins=origins)

    app.register_blueprint(user_blueprint, url_prefix="/api")
    app.register_blueprint(task_blueprint, url_prefix="/api")


def create_instance_dir(app):
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass
