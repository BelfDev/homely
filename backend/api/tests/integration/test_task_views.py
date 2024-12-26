from uuid import UUID
from src.task.models import Task, TaskStatus
from datetime import datetime
from .task_aux import (
    client_create_task,
)


def test_create_minimal_task_success(client, session):
    title = "Test Task"

    response = client_create_task(
        client,
        title=title,
    )

    assert response.status_code == 201
    data = response.get_json()

    # All expected fields
    expected_fields = {
        "id",
        "title",
        "status",
        "createdAt",
        "createdBy",
        "assignees",
    }
    assert set(data.keys()) == expected_fields

    # Required field values
    assert isinstance(data["id"], str)
    assert UUID(data["id"])
    assert data["title"] == title
    assert data["status"] == TaskStatus.OPENED.value.upper()

    # Optional fields (should be present but null)
    assert isinstance(data["assignees"], list)
    assert len(data["assignees"]) == 0

    # Automatically set fields
    assert isinstance(data["createdBy"], str)
    assert UUID(data["createdBy"])
    assert isinstance(data["createdAt"], str)

    # Verify database state
    task = session.query(Task).filter_by(id=data["id"]).first()
    assert task is not None

    # Required fields in DB
    assert task.title == title
    assert task.status == TaskStatus.OPENED

    # Optional fields in DB
    assert task.description is None
    assert task.start_at is None
    assert task.end_at is None
    assert len(task.assignees) == 0

    # Automatically set fields in DB
    assert task.created_by is not None
    assert isinstance(task.created_at, datetime)
    assert task.updated_at is None
