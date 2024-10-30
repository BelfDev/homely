import enum
import uuid
from dataclasses import dataclass
from datetime import datetime

from src.common.models.time import TimeWindow
from src.extensions.db import db, DBString, DBMapped, db_mapped_column, UUID, DBEnum, DBForeignKey, \
    db_composite, db_relationship, ormfunc


class TaskStatus(enum.Enum):
    OPENED = "opened"
    IN_PROGRESS = "in_progress"
    CONTESTED = "contested"
    DONE = "done"


@dataclass
class TaskAssignee(db.Model):
    __tablename__ = 'task_assignees'

    id: DBMapped[uuid.UUID] = db_mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    task_id: DBMapped[uuid.UUID] = db_mapped_column(UUID(as_uuid=True), DBForeignKey('tasks.id'), nullable=False)
    user_id: DBMapped[uuid.UUID] = db_mapped_column(UUID(as_uuid=True), DBForeignKey('users.id'), nullable=False)

    assigned_at: DBMapped[datetime] = db_mapped_column(nullable=False, server_default=ormfunc.now())
    updated_at: DBMapped[datetime] = db_mapped_column(nullable=True, onupdate=ormfunc.now())

    def __repr__(self):
        return f"<TaskAssignee task_id={self.task_id}, user_id={self.user_id}, assigned_at={self.assigned_at}>"


@dataclass
class Task(db.Model):
    __tablename__ = 'tasks'

    id: DBMapped[uuid.UUID] = db_mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    title: DBMapped[str] = db_mapped_column(DBString(140), nullable=False)
    description: DBMapped[str] = db_mapped_column(DBString(280), nullable=True)
    time_window: DBMapped[TimeWindow] = db_composite(
        db_mapped_column("start_time", nullable=True),
        db_mapped_column("end_time", nullable=True)
    )
    created_by: DBMapped[uuid.UUID] = db_mapped_column(UUID(as_uuid=True), DBForeignKey('users.id'), nullable=False)
    created_at: DBMapped[datetime] = db_mapped_column(nullable=False, server_default=ormfunc.now())
    updated_at: DBMapped[datetime] = db_mapped_column(nullable=True, onupdate=ormfunc.now())

    status: DBMapped[TaskStatus] = db_mapped_column(
        DBEnum(TaskStatus),
        name="task_status",
        nullable=False,
        default=TaskStatus.OPENED
    )
    assignees: DBMapped[list] = db_relationship(
        TaskAssignee,
        backref='task',
        lazy='subquery',
        collection_class=list
    )

    def __repr__(self):
        return f"<Task {self.title}, status: {self.status}>"
