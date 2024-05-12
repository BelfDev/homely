from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column

from api.extensions.db import db


class User(db.Model):
    id: Mapped[int] = mapped_column(primary_key=True)
    email: Mapped[str] = mapped_column(String(length=120), unique=True, nullable=False)
    first_name: Mapped[str] = mapped_column(String(80), unique=False, nullable=False)
    last_name: Mapped[str] = mapped_column(String(80), unique=False, nullable=False)

    def to_json(self):
        return {
            "id": self.id,
            "email": self.email,
            "firstName": self.first_name,
            "lastName": self.last_name,
        }
