from flask import Blueprint, render_template, abort

bp = Blueprint('user', __name__)

@bp.route('/api/v1/users')
def register_user():