from uuid import UUID
from src.task.models import Task, TaskStatus
from datetime import datetime, timedelta, timezone

from tests.integration.common_aux import db_add_test_user, is_valid_iso_timestamp
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


def test_create_complete_task_success(client, session):
    title = "Complete Task"
    description = "This is a complete task with all fields"
    start_at = datetime.now(timezone.utc)
    end_at = start_at + timedelta(days=7)

    assignee = db_add_test_user(
        session, email="assignee@example.com", first_name="Test", last_name="Assignee"
    )
    assignees = [str(assignee.id)]

    response = client_create_task(
        client,
        title=title,
        description=description,
        assignees=assignees,
        start_at=start_at,
        end_at=end_at,
    )

    assert response.status_code == 201
    data = response.get_json()

    # Verify all fields are present
    expected_fields = {
        "id",
        "title",
        "description",
        "status",
        "createdAt",
        "createdBy",
        "startAt",
        "endAt",
        "assignees",
    }
    assert set(data.keys()) == expected_fields

    # Verify field values
    assert isinstance(data["id"], str)
    assert UUID(data["id"])
    assert data["title"] == title
    assert data["description"] == description
    assert data["status"] == TaskStatus.OPENED.value.upper()
    assert isinstance(data["assignees"], list)
    assert len(data["assignees"]) == 1
    assert UUID(data["assignees"][0]["userId"]) == assignee.id

    # Verify timestamps
    assert is_valid_iso_timestamp(data["createdAt"])
    assert is_valid_iso_timestamp(data["startAt"])
    assert is_valid_iso_timestamp(data["endAt"])

    # Verify database state
    task = session.query(Task).filter_by(id=data["id"]).first()
    assert task is not None
    assert task.title == title
    assert task.description == description
    assert task.status == TaskStatus.OPENED
    assert len(task.assignees) == 1
    assert task.assignees[0].user_id == assignee.id


def test_create_task_unauthorized(client, session):
    title = "Test Task"

    response = client_create_task(
        client,
        title=title,
        authenticated=False,
    )

    # Verify response status and message
    assert response.status_code == 401
    data = response.get_json()
    assert data["msg"] == "Missing Authorization Header"

    # Verify no task was created in database
    task_count = session.query(Task).count()
    assert task_count == 0


def test_create_task_with_no_dates(client, session):
    response = client_create_task(client, title="No Dates Task")

    assert response.status_code == 201
    data = response.get_json()

    assert "startAt" not in data
    assert "endAt" not in data

    # Verify task in the database has null dates
    task = session.query(Task).filter_by(id=data["id"]).first()
    assert task.start_at is None
    assert task.end_at is None


def test_create_task_with_only_start_at(client, session):
    start_at = datetime.now(timezone.utc)
    response = client_create_task(client, title="Start Only Task", start_at=start_at)

    assert response.status_code == 201
    data = response.get_json()

    assert is_valid_iso_timestamp(data["startAt"])
    assert "endAt" not in data

    # Verify task in the database
    task = session.query(Task).filter_by(id=data["id"]).first()
    assert task.start_at is not None
    assert task.end_at is None


def test_create_task_with_valid_dates(client, session):
    start_at = datetime.now(timezone.utc)
    end_at = start_at + timedelta(days=1)
    response = client_create_task(
        client, title="Valid Dates Task", start_at=start_at, end_at=end_at
    )

    assert response.status_code == 201
    data = response.get_json()

    assert is_valid_iso_timestamp(data["startAt"])
    assert is_valid_iso_timestamp(data["startAt"])
    assert datetime.fromisoformat(
        data["endAt"].replace("Z", "+00:00")
    ) > datetime.fromisoformat(data["startAt"].replace("Z", "+00:00"))

    # Verify task in the database
    task = session.query(Task).filter_by(id=data["id"]).first()
    assert task.start_at is not None
    assert task.end_at is not None


def test_create_task_with_end_at_before_start_at(client, session):
    start_at = datetime.now(timezone.utc)
    end_at = start_at - timedelta(days=1)

    response = client_create_task(
        client, title="Invalid Date Range Task", start_at=start_at, end_at=end_at
    )
    assert response.status_code == 400

    # Verify no task was created in database
    task_count = session.query(Task).count()
    assert task_count == 0


def test_create_task_with_end_at_equal_to_start_at(client, session):
    start_at = datetime.now(timezone.utc)
    response = client_create_task(
        client,
        title="Equal Dates Task",
        start_at=start_at,
        end_at=start_at,
    )

    assert response.status_code == 400

    # Verify no task was created in database
    task_count = session.query(Task).count()
    assert task_count == 0


def test_create_task_with_only_end_at(client, session):
    """Test that creating a task with only end_at fails."""
    end_at = datetime.now(timezone.utc)
    response = client_create_task(client, title="End Only Task", end_at=end_at)

    assert response.status_code == 400

    # Verify no task was created in database
    task_count = session.query(Task).count()
    assert task_count == 0


def test_create_task_with_far_future_dates(client, session):
    start_at = datetime.now(timezone.utc)
    end_at = start_at + timedelta(days=365)  # One year later

    response = client_create_task(
        client, title="Future Task", start_at=start_at, end_at=end_at
    )
    assert response.status_code == 201
    data = response.get_json()

    assert (
        datetime.fromisoformat(data["startAt"].replace("Z", "+00:00")).date()
        == start_at.date()
    )
    assert (
        datetime.fromisoformat(data["endAt"].replace("Z", "+00:00")).date()
        == end_at.date()
    )

    # Verify task in the database
    task = session.query(Task).filter_by(id=data["id"]).first()
    assert task.start_at is not None
    assert task.end_at is not None


def test_create_task_with_timezone_dates(client, session):
    start_at = datetime.now(timezone.utc)
    end_at = start_at.astimezone(timezone(timedelta(hours=1))) + timedelta(days=1)

    response = client_create_task(
        client, title="Timezone Task", start_at=start_at, end_at=end_at
    )
    assert response.status_code == 201
    data = response.get_json()

    # Verify dates are normalized to UTC
    start_returned = datetime.fromisoformat(data["startAt"].replace("Z", "+00:00"))
    end_returned = datetime.fromisoformat(data["endAt"].replace("Z", "+00:00"))
    assert end_returned > start_returned

    # Verify task in the database
    task = session.query(Task).filter_by(id=data["id"]).first()
    assert task.start_at is not None
    assert task.end_at is not None
