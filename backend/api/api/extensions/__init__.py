"""Extension module"""

from .db import db, init_app
from .extensions import cors, migrate
from .jwt import jwt, init_app
