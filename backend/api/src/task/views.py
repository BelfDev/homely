from flask import Blueprint, request, jsonify

from src.extensions import (
    db,
    ValidationError,
    jwt_required,
    current_user,
)
from src.task.models import Task, TaskStatus
from src.task.schemas import TaskWireInSchema, TaskWireOutSchema

bp = Blueprint("tasks", __name__)
# task_schema = TaskSchema()
task_wire_in_schema = TaskWireInSchema()
task_wire_out_schema = TaskWireOutSchema()


@bp.route("/v1/tasks", methods=["POST"])
@jwt_required()
def create_task():
    if not request.is_json:
        return jsonify({"msg": "Missing JSON in request"}), 400

    data = request.json
    try:
        # Load input data and create the task object
        new_task = task_wire_in_schema.load(data)
    except ValidationError as err:
        return jsonify(err.messages), 400

    # Set additional fields like creator and status
    new_task.created_by = current_user.id
    new_task.status = TaskStatus.OPENED

    # Add and commit the new task to the database
    db.session.add(new_task)
    db.session.commit()

    # Fetch the task from the database to ensure all relationships are loaded
    task_from_db = Task.query.get(new_task.id)

    # Serialize the task for response
    result = task_wire_out_schema.dump(task_from_db)
    return jsonify(result), 201
