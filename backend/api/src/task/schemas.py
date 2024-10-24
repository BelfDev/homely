from src.extensions import WireSchema, fields, validate
from .models import Task, TaskStatus
from src.common.models.time import TimeWindowSchema


class TaskSchema(WireSchema):
    class Meta:
        model = Task
        load_instance = True
        include_fk = True
        exclude = ("assignees",)

    id = fields.UUID(dump_only=True)
    title = fields.String(required=True, validate=validate.Length(min=1, max=140))
    description = fields.String(required=False, validate=validate.Length(max=280))
    time_window = fields.Nested(TimeWindowSchema(), required=False)
    created_by = fields.UUID(dump_only=True)
    created_at = fields.DateTime(dump_only=True)
    updated_at = fields.DateTime(dump_only=True)
    status = fields.String(
        required=True, validate=validate.OneOf([status.value for status in TaskStatus])
    )
