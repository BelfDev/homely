from api.extensions.db import db, DBString, DBMapped, db_mapped_column
from api.extensions.jwt import bcrypt


class User(db.Model):
    id: DBMapped[int] = db_mapped_column(primary_key=True)
    email: DBMapped[str] = db_mapped_column(DBString(length=120), unique=True, nullable=False)
    password_hash: DBMapped[str] = db_mapped_column(DBString(length=150), nullable=False)
    first_name: DBMapped[str] = db_mapped_column(DBString(80), unique=False, nullable=False)
    last_name: DBMapped[str] = db_mapped_column(DBString(80), unique=False, nullable=False)

    @property
    def password(self):
        raise AttributeError('password is not a readable attribute')

    @password.setter
    def password(self, password):
        self.password = bcrypt.generate_password_hash(password).decode('utf-8')

    def check_password(self, password):
        return bcrypt.check_password_hash(self.password_hash, password)

    def to_json(self):
        return {
            "id": self.id,
            "email": self.email,
            "firstName": self.first_name,
            "lastName": self.last_name,
        }
