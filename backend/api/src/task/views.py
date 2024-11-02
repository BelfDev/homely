from flask import Blueprint, request, jsonify

from src.extensions import (
    db,
    ValidationError,
    jwt_required,
    current_user,
)
from src.task.models import TaskStatus
from src.task.schemas import TaskWireInSchema

bp = Blueprint("tasks", __name__)
# task_schema = TaskSchema()
task_wire_in = TaskWireInSchema()

@bp.route("/v1/tasks", methods=["POST"])
@jwt_required()
def create_task():
    if not request.is_json:
        return jsonify({"msg": "Missing JSON in request"}), 400

    data = request.json
    try:
        new_task = task_wire_in.load(data)
    except ValidationError as err:
        return jsonify(err.messages), 400

    # Set the task creator and status, assuming TaskSchema does not handle these
    new_task.created_by = current_user.id
    new_task.status = TaskStatus.OPENED

    # Add and commit the new task to the database
    db.session.add(new_task)
    db.session.commit()

    # Return the created task
    result = task_wire_in.dump(new_task)
    return jsonify(result), 201
