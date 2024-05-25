from api.user.models import User

register_route = '/api/v1/users'
login_route = '/api/v1/users/login'


# Helper functions
def client_create_user(client, email, password, first_name, last_name):
    return client.post(register_route, json={
        "email": email,
        "password": password,
        "firstName": first_name,
        "lastName": last_name
    })


def client_login_user(client, email, password):
    return client.post(login_route, json={
        "email": email,
        "password": password
    })


def db_get_user_by_email(app, email):
    with app.app_context():
        return User.query.filter_by(email=email).first()


def db_add_user(db, user: User):
    db.session.add(user)
    db.session.commit()
    return user
