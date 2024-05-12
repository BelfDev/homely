from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import DeclarativeBase


class Base(DeclarativeBase):
    pass


db = SQLAlchemy(model_class=Base)


def init_app(app):
    try:
        db.init_app(app)
        print("Database tables dropped and recreated successfully.")
    except Exception as e:
        print(f"An error occurred: {e}")
