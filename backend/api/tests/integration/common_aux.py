from datetime import datetime
from functools import lru_cache

from src.user.models import User


@lru_cache(maxsize=1)
def generate_valid_access_token(client):
    """
    Creates a test customer and returns their user id and access token.
    Uses lru_cache to avoid recreating the same customer multiple times.

    Args:
        client: Flask test client

    Returns:
        tuple: (user_email, access_token)
    """
    test_email = "test.user@example.com"
    test_password = "securepass123"

    response = client.post(
        "/api/v1/users",
        json={
            "email": test_email,
            "password": test_password,
            "firstName": "Test",
            "lastName": "User",
        },
    )

    data = response.get_json()
    user_id = data["id"] 
    access_token = data["accessToken"]
    
    return user_id, access_token


def is_valid_iso_timestamp(timestamp_str: str) -> bool:
    """Validate that a string is a valid ISO format timestamp."""
    try:
        datetime.fromisoformat(timestamp_str.replace("Z", "+00:00"))
        return True
    except ValueError:
        return False


def db_add_test_user(
    session,
    email: str = "test.user@example.com",
    password: str = "securepass123",
    first_name: str = "Test",
    last_name: str = "User",
    role: str = "user",
) -> User:
    """
    Creates and adds a test user to the database session.

    Args:
        session: SQLAlchemy session
        email: User email (optional)
        password: User password (optional)
        first_name: User first name (optional)
        last_name: User last name (optional)
        role: User role (optional)

    Returns:
        User: Created user instance
    """
    user = User(email=email, first_name=first_name, last_name=last_name, role=role)
    user.password = password

    session.add(user)
    session.flush() 

    return user
