from flask_marshmallow import Marshmallow
from marshmallow import INCLUDE, fields, validate, ValidationError, pre_load, post_load, post_dump

marsh = Marshmallow()
ValidationError = ValidationError
INCLUDE = INCLUDE
fields = fields
validate = validate
post_load = post_load
pre_load = pre_load
post_dump = post_dump
auto_field = marsh.auto_field


def camelcase(s):
    parts = iter(s.split("_"))
    return next(parts) + "".join(i.title() for i in parts)


class WireSchema(marsh.SQLAlchemyAutoSchema):
    """Schema that uses camel-case for its external representation
    and snake-case for its internal representation.
    """

    @staticmethod
    def on_bind_field(field_name, field_obj):
        field_obj.data_key = camelcase(field_obj.data_key or field_name)

    @post_dump
    def remove_none_values(self, data, **kwargs):
        """Remove keys with None values from serialized output."""
        return {key: value for key, value in data.items() if value is not None}
