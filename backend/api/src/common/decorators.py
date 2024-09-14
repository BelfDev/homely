import uuid
from functools import wraps

from flask import jsonify

from src.extensions import jwt, jwt_required, get_jwt_identity
from src.user.models import User


@jwt.user_identity_loader
def user_identity_lookup(user_dict):
    return {"id": user_dict["id"], "role": user_dict["role"]}


@jwt.user_lookup_loader
def user_lookup_callback(_jwt_header, jwt_data):
    identity = uuid.UUID(jwt_data["sub"]["id"])
    return User.query.filter_by(id=identity).one_or_none()


def roles_required(*roles):
    def decorator(func):
        @wraps(func)
        @jwt_required()
        def wrapper(*args, **kwargs):
            current_user = get_jwt_identity()
            if current_user["role"] not in roles:
                return jsonify({"msg": "Access denied: Insufficient role"}), 403
            return func(*args, **kwargs)

        return wrapper

    return decorator
