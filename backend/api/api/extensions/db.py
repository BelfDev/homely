from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import DeclarativeBase
from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column, relationship


class Base(DeclarativeBase):
    pass


db = SQLAlchemy(model_class=Base)

# Aliases
DBString = String
DBMapped = Mapped
db_mapped_column = mapped_column
db_relationship = relationship()


def init_app(app):
    try:
        db.init_app(app)
        print("Database tables dropped and recreated successfully.")
    except Exception as e:
        print(f"An error occurred: {e}")
