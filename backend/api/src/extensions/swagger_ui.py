from flask_swagger_ui import get_swaggerui_blueprint

# URL for exposing Swagger UI
SWAGGER_URL = "/docs"
# Path to the OpenAPI spec file
API_URL = "/static/openapi.yaml"


def init_app(app):
    swaggerui_blueprint = get_swaggerui_blueprint(
        SWAGGER_URL, API_URL, config={"app_name": "Homely API"}
    )
    app.register_blueprint(swaggerui_blueprint, url_prefix=SWAGGER_URL)
