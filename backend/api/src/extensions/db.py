from datetime import datetime

from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import String, DateTime, Enum, ForeignKey, func, CheckConstraint
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import (
    registry,
    Mapped,
    mapped_column,
    relationship,
    composite,
)

from src.extensions.extensions import migrate
from src.extensions.marshmallow import marsh

mapper_registry = registry(
    type_annotation_map={
        datetime: DateTime(timezone=True),
    }
)
Base = mapper_registry.generate_base()
db = SQLAlchemy(model_class=Base)

# Aliases
DBString = String
DBMapped = Mapped
DBDateTime = DateTime
DBEnum = Enum
DBForeignKey = ForeignKey
db_composite = composite
db_mapped_column = mapped_column
db_relationship = relationship
UUID = PGUUID
ormfunc = func
DBCheckConstraint = CheckConstraint


def init_app(app):
    try:
        db.init_app(app)
        marsh.init_app(app)
        migrate.init_app(app, db)
        print("Database initialized successfully.")
    except Exception as e:
        print(f"An error occurred: {e}")
