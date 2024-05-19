"""Extension module"""

from .db import db, init_app as db_init_app
from .extensions import cors, migrate
from .jwt import jwt, init_app
from .marshmallow import marsh, WireSchema, fields, validate, INCLUDE, ValidationError, post_load
