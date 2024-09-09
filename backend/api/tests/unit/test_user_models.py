import pytest

from src.user.models import User


def test_password_setter():
    user = User(password="mypassword")
    assert user.password_hash is not None


def test_no_password_getter():
    user = User(password="mypassword")
    with pytest.raises(AttributeError):
        user.password()


def test_password_verification():
    user = User(password="mypassword")
    assert user.check_password("mypassword")
    assert not user.check_password("wrongpassword")


def test_password_salts_are_random():
    user1 = User(password="mypassword")
    user2 = User(password="mypassword")
    assert user1.password_hash != user2.password_hash
