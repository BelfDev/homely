from typing import List
from uuid import UUID

from flask import jsonify

from src.extensions import db
from src.task.models import TaskAssignee
from src.user.models import User


def add_assignees(assignee_ids: List[UUID], task_id: UUID):
    if not assignee_ids:
        return

    assignees = User.query.filter(User.id.in_(assignee_ids)).all()

    if len(assignees) != len(assignee_ids):
        return jsonify({"msg": "One or more assignee IDs are invalid"}), 400

    for user in assignees:
        task_assignee = TaskAssignee(user_id=user.id, task_id=task_id)
        db.session.add(task_assignee)
