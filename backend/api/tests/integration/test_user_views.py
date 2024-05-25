from api.user.models import User

register_route = '/api/v1/users'
login_route = '/api/v1/users/login'


def test_register_user(client, app):
    valid_email = "test@test.com"

    # Check if user is not in the database
    with app.app_context():
        user = User.query.filter_by(email=valid_email).first()
        assert user is None

    # Given valid user data,
    # when registering a new user,
    # then the user is created.
    response = client.post(register_route, json={
        "email": valid_email,
        "password": "test123",
        "firstName": "Test",
        "lastName": "User"
    })
    assert response.status_code == 201
    data = response.get_json()
    assert data['email'] == "test@test.com"
    assert 'id' in data

    # Check if user is in the database
    with app.app_context():
        user = User.query.filter_by(email="test@test.com").first()
        assert user is not None
        assert user.email == valid_email

    # Given the user exists,
    # when registering the same user,
    # then the user is not created and an error is returned.
    response = client.post(register_route, json={
        "email": valid_email,
        "password": "test123",
        "firstName": "Test",
        "lastName": "User"
    })
    assert response.status_code == 400
    data = response.get_json()
    assert data['msg'] == "Email already exists"

    # Given missing fields,
    # when registering a new user,
    # then an error is returned.
    response = client.post(register_route, json={
        "email": "test2@test.com",
        "password": "test123"
    })
    assert response.status_code == 400

    # Given invalid email,
    # when registering a new user,
    # then an error is returned.
    response = client.post(register_route, json={
        "email": "not-an-email",
        "password": "test123",
        "firstName": "Test",
        "lastName": "User"
    })
    assert response.status_code == 400


def test_login_success(client, db):
    # Create a test user
    user = User(email="test@test.com", password="test123", first_name="Test", last_name="User")
    db.session.add(user)
    db.session.commit()

    # Attempt to login with correct credentials
    response = client.post(login_route, json={
        "email": "test@test.com",
        "password": "test123"
    })
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
    db.session.add(user)
    db.session.commit()

    # Attempt to login with incorrect email
    response = client.post(login_route, json={
        "email": "wrong@test.com",
        "password": "test123"
    })
    assert response.status_code == 401
    data = response.get_json()
    assert data['msg'] == "Bad email or password"


def test_login_incorrect_password(client, db):
    # Create a test user
    user = User(email="test2@test.com", password="test123", first_name="Test", last_name="User")
    db.session.add(user)
    db.session.commit()

    # Attempt to login with incorrect password
    response = client.post(login_route, json={
        "email": "test2@test.com",
        "password": "wrongpassword"
    })
    assert response.status_code == 401
    data = response.get_json()
    assert data['msg'] == "Bad email or password"
