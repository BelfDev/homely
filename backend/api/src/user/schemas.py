from src.extensions import WireSchema, fields, validate
from .models import User


class UserSchema(WireSchema):
    class Meta:
        model = User
        load_instance = True
        exclude = ("password_hash",)

    id = fields.UUID(dump_only=True)
    email = fields.Email(required=True, validate=validate.Length(min=1, max=120))
    password = fields.String(
        required=True, load_only=True, validate=validate.Length(min=6, max=150)
    )
    first_name = fields.String(required=True, validate=validate.Length(min=1, max=80))
    last_name = fields.String(required=True, validate=validate.Length(min=1, max=80))
    role = fields.String(dump_only=True, validate=validate.Length(min=1, max=80))


class LoginSchema(WireSchema):
    email = fields.Email(required=True, validate=validate.Length(min=1, max=120))
    password = fields.String(required=True, validate=validate.Length(min=6, max=150))
