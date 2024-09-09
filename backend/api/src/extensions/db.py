from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import String
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import DeclarativeBase
from sqlalchemy.orm import Mapped, mapped_column, relationship

from src.extensions.extensions import migrate
from src.extensions.marshmallow import marsh


class Base(DeclarativeBase):
    pass


db = SQLAlchemy(model_class=Base)

# Aliases
DBString = String
DBMapped = Mapped
db_mapped_column = mapped_column
db_relationship = relationship()
UUID = UUID


def init_app(app):
    try:
        db.init_app(app)
        marsh.init_app(app)
        migrate.init_app(app, db)
        print("Database tables dropped and recreated successfully.")
    except Exception as e:
        print(f"An error occurred: {e}")
