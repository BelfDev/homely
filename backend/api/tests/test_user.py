import json
from api.user.models import User


def test_register_user(client, db):
    endpoint = '/api/v1/users'

    # Given valid user data,
    # when registering a new user,
    # then the user is created.
    response = client.post(endpoint, json={
        "email": "test@test.com",
        "password": "test123",
        "firstName": "Test",
        "lastName": "User"
    })
    assert response.status_code == 201
    data = response.get_json()
    assert data['email'] == "test@test.com"
    assert 'id' in data

    # Given the user exists,
    # when registering the same user,
    # then the user is not created and an error is returned.
    response = client.post(endpoint, json={
        "email": "test@test.com",
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
    response = client.post(endpoint, json={
        "email": "test2@test.com",
        "password": "test123"
    })
    assert response.status_code == 400

    # Given invalid email,
    # when registering a new user,
    # then an error is returned.
    response = client.post(endpoint, json={
        "email": "not-an-email",
        "password": "test123",
        "firstName": "Test",
        "lastName": "User"
    })
    assert response.status_code == 400
