import enum
import uuid
from dataclasses import dataclass
from datetime import datetime, UTC

from src.common.models.time import TimeWindow
from src.extensions.db import db, DBString, DBMapped, db_mapped_column, UUID, DBDateTime, DBEnum, DBForeignKey, \
    db_composite, db_relationship


class TaskStatus(enum.Enum):
    OPENED = "opened"
    IN_PROGRESS = "in_progress"
    CONTESTED = "contested"
    DONE = "done"


@dataclass(frozen=True)
class TaskAssignee(db.Model):
    __tablename__ = 'task_assignees'

    id: DBMapped[uuid.UUID] = db_mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    task_id: DBMapped[uuid.UUID] = db_mapped_column(UUID(as_uuid=True), DBForeignKey('tasks.id'), nullable=False)
    user_id: DBMapped[uuid.UUID] = db_mapped_column(UUID(as_uuid=True), DBForeignKey('users.id'), nullable=False)

    assigned_at: DBMapped[datetime] = db_mapped_column(DBDateTime, nullable=False, default=datetime.now(UTC))
    updated_at: DBMapped[datetime] = db_mapped_column(DBDateTime, nullable=True, onupdate=datetime.now(UTC))

    def __repr__(self):
        return f"<TaskAssignee task_id={self.task_id}, user_id={self.user_id}, assigned_at={self.assigned_at}>"


@dataclass(frozen=True)
class Task(db.Model):
    __tablename__ = 'tasks'

    id: DBMapped[uuid.UUID] = db_mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    title: DBMapped[str] = db_mapped_column(DBString(140), unique=False, nullable=False)
    description: DBMapped[str] = db_mapped_column(DBString(280), unique=False, nullable=False)
    time_window: DBMapped[TimeWindow] = db_composite(TimeWindow)
    created_by: DBMapped[uuid.UUID] = db_mapped_column(UUID(as_uuid=True), DBForeignKey('users.id'), nullable=False)
    created_at: DBMapped[datetime] = db_mapped_column(DBDateTime, nullable=False, default=datetime.now(UTC))
    updated_at: DBMapped[datetime] = db_mapped_column(DBDateTime, nullable=True, onupdate=datetime.now(UTC))
    status: DBMapped[TaskStatus] = db_mapped_column(DBEnum(TaskStatus), nullable=False, default=TaskStatus.OPENED)

    assignees: DBMapped[list] = db_relationship('TaskAssignee', backref='task', lazy='subquery')

    def __repr__(self):
        return f"<Task {self.title}, status: {self.status}>"
