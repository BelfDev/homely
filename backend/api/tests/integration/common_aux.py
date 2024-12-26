from datetime import datetime
from functools import lru_cache


@lru_cache(maxsize=1)
def generate_valid_access_token(client):
    """
    Creates a test customer and returns their access token.
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
    access_token = data["accessToken"]

    return access_token


def is_valid_iso_timestamp(timestamp_str: str) -> bool:
    """Validate that a string is a valid ISO format timestamp."""
    try:
        datetime.fromisoformat(timestamp_str.replace("Z", "+00:00"))
        return True
    except ValueError:
        return False
