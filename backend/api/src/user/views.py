from flask import Blueprint, request, jsonify

from src.common.decorators import roles_required
from src.extensions import (
    db,
    ValidationError,
    create_access_token,
    jwt_required,
    current_user,
)
from src.user.models import User
from src.user.schemas import UserSchema, LoginSchema

bp = Blueprint("user", __name__)
user_schema = UserSchema()
login_schema = LoginSchema()


@bp.route("/v1/users", methods=("POST",))
def register_user():
    # Check if request is JSON
    if not request.is_json:
        return jsonify({"msg": "Missing JSON in request"}), 400

    # Validate JSON
    data = request.json
    try:
        # Load JSON into User object
        new_user = user_schema.load(data)
    except ValidationError as err:
        # Return validation errors
        return jsonify(err.messages), 400

    # Idempotent check
    if User.query.filter_by(email=new_user.email).first():
        return jsonify({"msg": "Email already exists"}), 400

    # Create new user
    new_user.password = data["password"]
    db.session.add(new_user)
    db.session.commit()

    # Return new user
    result = user_schema.dump(new_user)
    # Create access token
    result["accessToken"] = create_access_token(identity={"id": str(result.id), "role": result.role})
    # Return new user
    return jsonify(result), 201


@bp.route("/v1/users/login", methods=("POST",))
def login():
    # Check if request is JSON
    if not request.is_json:
        return jsonify({"msg": "Missing JSON in request"}), 400

    # Validate JSON
    data = request.json
    try:
        # Load JSON into User object
        login_data = login_schema.load(data)
    except ValidationError as err:
        # Return validation errors
        return jsonify(err.messages), 400

    email = login_data["email"]
    password = login_data["password"]

    user = User.query.filter_by(email=email).first()

    if user is None or not user.check_password(password):
        return jsonify({"msg": "Bad email or password"}), 401

    access_token = create_access_token(identity={"id": str(user.id), "role": user.role})
    return jsonify(accessToken=access_token), 200


@bp.route("/v1/admin/users", methods=("GET",))
@roles_required("admin")
def get_all_users():
    users = User.query.all()
    result = user_schema.dump(users, many=True)
    return jsonify({"users": result}), 200


@bp.route("/v1/users/me", methods=["GET"])
@jwt_required()
def get_current_user():
    result = user_schema.dump(current_user)
    return jsonify(result), 200
