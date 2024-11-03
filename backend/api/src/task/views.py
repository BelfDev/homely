from pprint import pprint

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
task_wire_in = TaskWireInSchema()
task_wire_out = TaskWireOutSchema()


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

    new_task.created_by = current_user.id

    db.session.add(new_task)
    db.session.commit()

    task_from_db = Task.query.get(new_task.id)

    return task_wire_out.dump(task_from_db), 201


@bp.route("/v1/tasks", methods=["GET"])
@jwt_required()
def get_all_tasks():
    user_tasks = Task.query.filter_by(created_by=current_user.id).all()
    return task_wire_out.dump(user_tasks, many=True), 200


@bp.route("/v1/tasks/<uuid:task_id>", methods=["GET"])
@jwt_required()
def get_task(task_id):
    task = Task.query.get_or_404(task_id)
    if not task.created_by == current_user.id:
        return jsonify({"msg": "Task not found or access is forbidden"}), 404

    return task_wire_out.dump(task), 200


@bp.route("/v1/tasks/<uuid:task_id>", methods=["PUT", "PATCH"])
@jwt_required()
def update_task(task_id):
    if not request.is_json:
        return jsonify({"msg": "Missing JSON in request"}), 400

    task = Task.query.get_or_404(task_id)
    if task.created_by != current_user.id:
        return jsonify({"msg": "Task not found or access is forbidden"}), 404

    data = request.json

    try:
        task_wire_in.load(data, instance=task, partial=True)
    except ValidationError as err:
        return jsonify(err.messages), 400

    pprint(task)
    db.session.commit()

    # Return the updated task data
    return task_wire_out.dump(task), 200
