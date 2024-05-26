import uuid

from api.extensions.db import db, DBString, DBMapped, db_mapped_column, UUID
from api.extensions.jwt import bcrypt


class User(db.Model):
    __tablename__ = "users"

    id: DBMapped[int] = db_mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    email: DBMapped[str] = db_mapped_column(DBString(length=120), unique=True, nullable=False)
    password_hash: DBMapped[str] = db_mapped_column(DBString(length=150), nullable=False)
    first_name: DBMapped[str] = db_mapped_column(DBString(80), unique=False, nullable=False)
    last_name: DBMapped[str] = db_mapped_column(DBString(80), unique=False, nullable=False)

    @property
    def password(self):
        raise AttributeError('password is not a readable attribute')

    @password.setter
    def password(self, password):
        self.password_hash = bcrypt.generate_password_hash(password).decode('utf-8')

    def check_password(self, password):
        return bcrypt.check_password_hash(self.password_hash, password)
