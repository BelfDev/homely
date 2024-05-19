from flask import (
    Blueprint, request, jsonify
)

from api.extensions import db, ValidationError, create_access_token, jwt_required
from api.user.models import User
from api.user.schemas import UserSchema, LoginSchema

bp = Blueprint('user', __name__, url_prefix='/v1/users')
user_schema = UserSchema()
login_schema = LoginSchema()


@bp.route('/v1/users', methods=('POST',))
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
    return jsonify(result), 201


@bp.route('/v1/users/login', methods=('POST',))
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

    email = login_data['email']
    password = login_data['password']

    user = User.query.filter_by(email=email).first()

    if user is None or not user.check_password(password):
        return jsonify({"msg": "Bad email or password"}), 401

    access_token = create_access_token(identity=email)
    return jsonify(access_token=access_token), 200


@bp.route('/v1/admin/users', methods=('GET',))
def get_all_users():
    users = User.query.all()
    result = user_schema.dump(users, many=True)
    return jsonify({"users": result}), 200
