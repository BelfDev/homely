from typing import List
from uuid import UUID

from flask import jsonify

from src.task.models import TaskAssignee
from src.user.models import User

from src.extensions import (
    db,
    ValidationError,
)


def add_assignees(assignee_ids: List[UUID], task_id: UUID):
    if not assignee_ids:
        return

    assignees = User.query.filter(User.id.in_(assignee_ids)).all()

    if len(assignees) != len(assignee_ids):
        raise ValidationError(
            "One or more assignee IDs are invalid",
            field_name="assignees",
        )

    for user in assignees:
        task_assignee = TaskAssignee(user_id=user.id, task_id=task_id)
        db.session.add(task_assignee)
