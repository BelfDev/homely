from flask_bcrypt import Bcrypt
from flask_jwt_extended import (JWTManager, create_access_token, jwt_required, current_user)

jwt = JWTManager()
bcrypt = Bcrypt()

create_access_token = create_access_token
jwt_required = jwt_required
current_user = current_user


def init_app(app):
    jwt.init_app(app)
    bcrypt.init_app(app)
