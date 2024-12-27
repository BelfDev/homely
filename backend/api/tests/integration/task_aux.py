from datetime import datetime
from flask import Response
from typing import List, Optional
from tests.integration.common_aux import generate_valid_access_token

tasks_route = "/api/v1/tasks"


def client_create_task(
    client,
    title: str,
    description: Optional[str] = None,
    assignees: Optional[List[str]] = None,
    status: Optional[str] = None,
    start_at: Optional[datetime] = None,
    end_at: Optional[datetime] = None,
    authenticated: bool = True,
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

    Returns:
        Response: Flask test client response
    """
    headers: Dict[str, str] = {}
    if authenticated:
        access_token = generate_valid_access_token(client)
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

    return client.post(
        tasks_route,
        json=data,
        headers=headers,
    )
