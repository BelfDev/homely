"""Extension module"""

from .db import db, init_app as db_init_app
from .extensions import cors, migrate
from .jwt import (
    jwt,
    create_access_token,
    jwt_required,
    current_user,
    get_jwt_identity,
)
from .marshmallow import (
    marsh,
    WireSchema,
    fields,
    validate,
    INCLUDE,
    EXCLUDE,
    ValidationError,
    post_load,
    pre_load,
    post_dump,
    auto_field,
)
from .swagger_ui import init_app
