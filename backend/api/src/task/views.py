from flask import Blueprint, request, jsonify

from src.extensions import (
    db,
    ValidationError,
    jwt_required,
    current_user,
)
from src.task.models import Task
from src.task.schemas import TaskWireInSchema, TaskWireOutSchema

bp = Blueprint("tasks", __name__)
task_wire_in_schema = TaskWireInSchema()
task_wire_out_schema = TaskWireOutSchema()


@bp.route("/v1/tasks", methods=["POST"])
@jwt_required()
def create_task():
    if not request.is_json:
        return jsonify({"msg": "Missing JSON in request"}), 400

    data = request.json
    try:
        new_task = task_wire_in_schema.load(data)
    except ValidationError as err:
        return jsonify(err.messages), 400

    new_task.created_by = current_user.id

    db.session.add(new_task)
    db.session.commit()

    task_from_db = Task.query.get(new_task.id)

    result = task_wire_out_schema.dump(task_from_db)
    return result, 201


@bp.route("/v1/tasks/<uuid:task_id>", methods=["GET"])
@jwt_required()
def get_task(task_id):
    task = Task.query.get_or_404(task_id)
    return task_wire_out_schema.dump(task), 200
