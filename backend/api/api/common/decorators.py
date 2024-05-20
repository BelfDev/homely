import uuid

from api.extensions import jwt
from api.user.models import User


@jwt.user_identity_loader
def user_identity_lookup(user_id):
    return user_id


@jwt.user_lookup_loader
def user_lookup_callback(_jwt_header, jwt_data):
    identity = uuid.UUID(jwt_data["sub"])
    return User.query.filter_by(id=identity).one_or_none()
