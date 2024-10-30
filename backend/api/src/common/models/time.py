from dataclasses import dataclass
from datetime import datetime

from src.extensions import WireSchema, fields


@dataclass
class TimeWindow:
    start_time: datetime
    end_time: datetime

    def __repr__(self):
        return f"<TimeWindow start: {self.start_time}, end: {self.end_time}>"


class TimeWindowSchema(WireSchema):
    start_time = fields.DateTime(required=False)
    end_time = fields.DateTime(required=False)

    class Meta:
        # No model mapping is needed here because TimeWindow is a composite, not a full SQLAlchemy model
        ordered = True
