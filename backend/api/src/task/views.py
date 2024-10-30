from flask import Blueprint, request, jsonify

from src.extensions import (
    db,
    ValidationError,
    jwt_required,
    current_user,
)
from src.task.models import TaskStatus
from src.task.schemas import TaskSchema
from src.user.models import User

bp = Blueprint("tasks", __name__)
task_schema = TaskSchema()


@bp.route("/v1/tasks", methods=["POST"])
@jwt_required()
def create_task():
    if not request.is_json:
        return jsonify({"msg": "Missing JSON in request"}), 400

    data = request.json
    try:
        new_task = task_schema.load(data)
    except ValidationError as err:
        return jsonify(err.messages), 400

    # Retrieve all matching User objects
    assignee_ids = data.get("assignees", [])
    assignees = User.query.filter(User.id.in_(assignee_ids)).all()

    # Validate that the number of retrieved assignees matches the number of provided IDs
    if len(assignees) != len(assignee_ids):
        return jsonify({"msg": "One or more assignee IDs are invalid."}), 400

    # Set the task creator and status, assuming TaskSchema does not handle these
    new_task.created_by = current_user.id
    new_task.status = TaskStatus.OPENED
    new_task.assignees = assignees

    # Add and commit the new task to the database
    db.session.add(new_task)
    db.session.commit()

    # Return the created task
    result = task_schema.dump(new_task)
    return jsonify(result), 201
