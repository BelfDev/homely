from flask import Blueprint, request, jsonify

from src.extensions import (
    db,
    ValidationError,
    jwt_required,
    current_user,
)
from src.task.schemas import TaskSchema

bp = Blueprint("tasks", __name__)
task_schema = TaskSchema()


@bp.route("/v1/tasks", methods=["POST"])
@jwt_required()
def create_task():
    # TODO(BelfDev): Extract this to a common function
    if not request.is_json:
        return jsonify({"msg": "Missing JSON in request"}), 400

    # Validate and load the task data
    data = request.json
    try:
        new_task = task_schema.load(data)
    except ValidationError as err:
        return jsonify(err.messages), 400

    # Set the task creator as the current user
    new_task.created_by = current_user.id

    # Add the new task to the database
    db.session.add(new_task)
    db.session.commit()

    # Return the newly created task
    result = task_schema.dump(new_task)
    return jsonify(result), 201
