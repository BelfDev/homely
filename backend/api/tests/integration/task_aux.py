from datetime import datetime
from flask import Response
from typing import Dict, List, Optional
from src.task.schemas import TaskWireInSchema
from tests.integration.common_aux import generate_valid_access_token
from src.task.models import Task
from sqlalchemy.orm import Session
from uuid import UUID

tasks_route = "/api/v1/tasks"


def client_post_task(
    client,
    title: str,
    description: Optional[str] = None,
    assignees: Optional[List[str]] = None,
    status: Optional[str] = None,
    start_at: Optional[datetime] = None,
    end_at: Optional[datetime] = None,
    created_by: Optional[str] = None,
    authenticated: bool = True,
    access_token: Optional[str] = None,
) -> Response:
    """
    Create a task with all possible parameters.

    Args:
        client: Flask test client
        title: Task title (required)
        description: Task description (optional)
        assignees: List of assignee UUIDs as strings (optional)
        status: Task status (optional, defaults to OPENED)
        start_at: Start datetime (optional)
        end_at: End datetime (optional)
        authenticated: Whether to include authentication token (defaults to True)
        access_token: Access token (optional, autogenerates if abscent)

    Returns:
        Response: Flask test client response
    """
    headers: Dict[str, str] = {}
    if authenticated:
        if access_token is None:
            _, access_token = generate_valid_access_token(client)
        headers["Authorization"] = f"Bearer {access_token}"

    data = {
        "title": title,
    }

    # Add optional fields only if they are provided
    if description is not None:
        data["description"] = description
    if assignees is not None:
        data["assignees"] = assignees
    if status is not None:
        data["status"] = status
    if start_at is not None:
        data["startAt"] = start_at.isoformat()
    if end_at is not None:
        data["endAt"] = end_at.isoformat()
    if created_by is not None:
        data["createdBy"] = created_by

    return client.post(
        tasks_route,
        json=data,
        headers=headers,
    )


def client_get_my_tasks(client, access_token) -> Response:
    headers: Dict[str, str] = {}
    headers["Authorization"] = f"Bearer {access_token}"

    return client.get(
        tasks_route,
        headers=headers,
    )


def client_get_task(client, access_token, task_id) -> Response:
    headers: Dict[str, str] = {}
    headers["Authorization"] = f"Bearer {access_token}"

    return client.get(
        f"{tasks_route}/{task_id}",
        headers=headers,
    )


def client_put_task(client, task, access_token: Optional[str] = None) -> Response:
    headers: Dict[str, str] = {}
    if access_token is None:
        _, access_token = generate_valid_access_token(client)
    headers["Authorization"] = f"Bearer {access_token}"

    wire_in = TaskWireInSchema()
    data = wire_in.dump(task)

    return client.put(
        f"{tasks_route}/{task.id}",
        json=data,
        headers=headers,
    )


def client_patch_task(client, task, access_token: Optional[str] = None) -> Response:
    headers: Dict[str, str] = {}
    if access_token is None:
        _, access_token = generate_valid_access_token(client)
    headers["Authorization"] = f"Bearer {access_token}"

    wire_in = TaskWireInSchema()
    data = wire_in.dump(task)

    return client.patch(
        f"{tasks_route}/{task.id}",
        json=data,
        headers=headers,
    )


def db_add_task(session: Session, task: Task) -> Task:
    """
    Adds a new task to the database.

    Args:
    session (Session): The SQLAlchemy session to use for the transaction.
        task (Task): The task object to be added.

    Returns:
        Task: The task object.
    """

    session.add(task)
    session.commit()
    return task


def db_add_tasks(session: Session, tasks: List[dict]) -> List[Task]:
    """
    Adds multiple tasks to the database.

    Args:
        session (Session): The SQLAlchemy session to use for the transaction.
        tasks (List[dict]): A list of dictionaries containing task data.

    Returns:
        List[Task]: A list of task objects.
    """
    session.add_all(tasks)
    session.commit()
    return tasks
