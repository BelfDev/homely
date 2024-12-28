from datetime import datetime, timezone

from src.extensions import (
    WireSchema,
    fields,
    validate,
    pre_load,
    ValidationError,
)
from .models import TaskStatus, Task


class TaskWireInSchema(WireSchema):
    class Meta:
        model = Task
        include_fk = True
        load_instance = True

    title = fields.String(required=True, validate=validate.Length(min=1, max=140))
    description = fields.String(required=False, validate=validate.Length(max=280))
    start_at = fields.DateTime(
        required=False,
        validate=lambda val: val <= datetime.now(timezone.utc),
        error_messages={"validator_failed": "Start date cannot be in the past"},
    )
    end_at = fields.DateTime(required=False)
    created_by = fields.UUID(dump_only=True)
    created_at = fields.DateTime(dump_only=True)
    updated_at = fields.DateTime(dump_only=True)
    status = fields.Enum(
        TaskStatus,
        required=False,
        error_messages={"validator_failed": "Invalid task status."},
    )
    assignees = fields.List(fields.UUID(), required=False)

    @pre_load
    def validate_dates(self, data, **kwargs):
        """Validate task dates follow the rules:
        - Both can be null
        - Only start_at can be present
        - If both present, end_at must be after start_at
        """
        start_at = data.get("startAt")
        end_at = data.get("endAt")

        if end_at is not None:
            if start_at is None:
                raise ValidationError(
                    "start_at is required when end_at is provided",
                    field_name="start_at",
                )
            if start_at >= end_at:  # Changed from > to >=
                raise ValidationError(
                    "end_at must be after start_at", field_name="end_at"
                )

        return data


class TaskWireOutSchema(WireSchema):
    class Meta:
        model = Task
        include_fk = True

    assignees = fields.Method("adapt_assignees", dump_only=True)

    @staticmethod
    def adapt_assignees(task):
        """Convert assignees to a list of dictionaries with user details."""
        return [
            {
                "user_id": str(assignee.user_id),
                "first_name": assignee.user.first_name,
                "last_name": assignee.user.last_name,
            }
            for assignee in task.assignees
        ]
