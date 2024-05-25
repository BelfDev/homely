from api.user.models import User
from .user_aux import login_route, client_create_user, client_login_user, db_get_user_by_email, db_add_user, \
    all_users_route, current_user_route


def test_register_user_success(client, app):
    valid_email = "test@test.com"

    # Check if user is not in the database
    assert db_get_user_by_email(app, valid_email) is None

    # Given valid user data, when registering a new user, then the user is created
    response = client_create_user(client, valid_email, "test123", "Test", "User")
    assert response.status_code == 201
    data = response.get_json()
    assert data['email'] == valid_email
    assert 'id' in data

    # Check if user is in the database
    user = db_get_user_by_email(app, valid_email)
    assert user is not None
    assert user.email == valid_email


def test_register_user_existing_email(client, app):
    valid_email = "test@test.com"

    # Create a user
    client_create_user(client, valid_email, "test123", "Test", "User")

    # Given the user exists, when registering the same user, then the user is not created and an error is returned
    response = client_create_user(client, valid_email, "test123", "Test", "User")
    assert response.status_code == 400
    data = response.get_json()
    assert data['msg'] == "Email already exists"


def test_register_user_missing_fields(client):
    # Given missing fields, when registering a new user, then an error is returned
    response = client_create_user(client, "test2@test.com", "test123", "", "")
    assert response.status_code == 400


def test_register_user_invalid_email(client):
    # Given invalid email, when registering a new user, then an error is returned
    response = client_create_user(client, "not-an-email", "test123", "Test", "User")
    assert response.status_code == 400


def test_login_success(client, db):
    # Create a test user
    user = User(email="test@test.com", password="test123", first_name="Test", last_name="User")
    db_add_user(db, user)

    # Attempt to login with correct credentials
    response = client_login_user(client, "test@test.com", "test123")
    assert response.status_code == 200
    data = response.get_json()
    assert 'access_token' in data


def test_login_missing_json(client):
    # Attempt to login without JSON
    response = client.post(login_route)
    assert response.status_code == 400
    data = response.get_json()
    assert data['msg'] == "Missing JSON in request"


def test_login_invalid_json(client):
    # Attempt to login with invalid JSON
    response = client.post(login_route, json={"email": "test@test.com"})
    assert response.status_code == 400


def test_login_incorrect_email(client, db):
    # Create a test user
    user = User(email="test@test.com", password="test123", first_name="Test", last_name="User")
    db_add_user(db, user)

    # Attempt to login with incorrect email
    response = client_login_user(client, "wrong@test.com", "test123")
    assert response.status_code == 401
    data = response.get_json()
    assert data['msg'] == "Bad email or password"


def test_login_incorrect_password(client, db):
    # Create a test user
    user = User(email="test2@test.com", password="test123", first_name="Test", last_name="User")
    db_add_user(db, user)

    # Attempt to login with incorrect password
    response = client_login_user(client, "test2@test.com", "wrongpassword")
    assert response.status_code == 401
    data = response.get_json()
    assert data['msg'] == "Bad email or password"


def test_get_all_users(client, db):
    # Create test users
    db_add_user(db, User(email="test1@test.com", password="test123", first_name="Test", last_name="User"))
    db_add_user(db, User(email="test2@test.com", password="test123", first_name="Test", last_name="User"))

    # Attempt to get all users
    response = client.get(all_users_route)
    assert response.status_code == 200
    data = response.get_json()
    assert 'users' in data
    assert len(data['users']) == 2


def test_get_current_user(client, db):
    # Create a test user
    db_add_user(db, User(email="test@test.com", password="test123", first_name="Test", last_name="User"))

    # Login to get access token
    login_response = client_login_user(client, "test@test.com", "test123")
    assert login_response.status_code == 200
    access_token = login_response.get_json()['access_token']

    headers = {
        'Authorization': f'Bearer {access_token}'
    }

    # Attempt to get the current user's information
    response = client.get(current_user_route, headers=headers)
    assert response.status_code == 200
    data = response.get_json()
    assert data['email'] == "test@test.com"
    assert data['firstName'] == "Test"
    assert data['lastName'] == "User"
