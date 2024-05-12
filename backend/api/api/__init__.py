import os

from flask import Flask, jsonify

from api.config import DevConfig
from api.extensions import db, cors, migrate
from api.models import User


def create_app(config_object=DevConfig):
    # create and configure the app
    app = Flask(__name__,
                instance_relative_config=True,
                instance_path=config_object.INSTANCE_DIR)
    app.config.from_object(config)
    create_instance_dir(app)
    register_extensions(app)

    # a simple page that says hello
    @app.route('/hello')
    def hello():
        return 'Hello, World!'

    @app.route("/users", methods=["GET"])
    def users():
        db.create_all()
        result = User.query.all()
        json_users = list(map(lambda x: x.to_json(), result))

        return jsonify({"users": json_users})

    return app


def register_extensions(app):
    cors.init_app(app)
    db.init_app(app)
    migrate.init_app(app, db)


def create_instance_dir(app):
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass
