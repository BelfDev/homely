from src.extensions import WireSchema, fields, validate

class TaskSchema(WireSchema):
    class Meta:
        model = Task
        load_instance = True
        exclude = ("user_id",)

    id = fields.UUID(dump_only=True)
    title = fields.Email(required=True, validate=validate.Length(min=1, max=120))
