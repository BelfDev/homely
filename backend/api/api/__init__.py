import os

from flask import Flask, jsonify

from api.config import DevConfig
from api.extensions import db, db_init_app, cors, jwt, marsh, swagger_ui
from api.user import user_blueprint
from api.common import user_identity_lookup, user_lookup_callback


def create_app(config_object=DevConfig):
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

    with app.app_context():
        db.create_all()

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
    cors.init_app(user_blueprint, origins=origins)

    app.register_blueprint(user_blueprint, url_prefix="/api")


def create_instance_dir(app):
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass
