from src.common.models.time import TimeWindowSchema
from src.extensions import WireSchema, fields, validate, post_load, ValidationError
from src.user.models import User
from .models import TaskStatus, Task, TaskAssignee

class TaskWireInSchema(WireSchema):
    class Meta:
        include_fk = True

    title = fields.String(required=True, validate=validate.Length(min=1, max=140))
    description = fields.String(required=False, validate=validate.Length(max=280))
    time_window = fields.Nested(TimeWindowSchema(), required=False)
    created_by = fields.UUID(dump_only=True)
    created_at = fields.DateTime(dump_only=True)
    updated_at = fields.DateTime(dump_only=True)
    status = fields.String(
        dump_only=True, validate=validate.OneOf([status.value for status in TaskStatus])
    )
    assignees = fields.List(fields.UUID(), required=False)

    @post_load
    def make_task(self, data, **kwargs):
        assignee_ids = data.pop("assignees", [])
        task = Task(**data)

        if not assignee_ids:
            return task

        assignees = User.query.filter(User.id.in_(assignee_ids)).all()
        if len(assignees) != len(assignee_ids):
            raise ValidationError("One or more assignee IDs are invalid.", field_name="assignees")

        task_assignees = [TaskAssignee(user_id=assignee.id) for assignee in assignees]
        task.assignees = task_assignees

        return task
