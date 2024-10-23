from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import String, DateTime, Enum, ForeignKey
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column, relationship, composite

from src.extensions.extensions import migrate
from src.extensions.marshmallow import marsh


class Base(DeclarativeBase):
    pass


db = SQLAlchemy(model_class=Base)

# Aliases
DBString = String
DBMapped = Mapped
DBDateTime = DateTime
DBEnum = Enum
DBForeignKey = ForeignKey
db_composite = composite
db_mapped_column = mapped_column
db_relationship = relationship()
UUID = PGUUID


def init_app(app):
    try:
        db.init_app(app)
        marsh.init_app(app)
        migrate.init_app(app, db)
        print("Database initialized successfully.")
    except Exception as e:
        print(f"An error occurred: {e}")
