from dataclasses import dataclass
from datetime import datetime

from src.extensions import WireSchema, fields, post_load


@dataclass
class TimeWindow:
    start_time: datetime
    end_time: datetime

    def __repr__(self):
        return f"<TimeWindow start: {self.start_time}, end: {self.end_time}>"


class TimeWindowSchema(WireSchema):
    class Meta:
        ordered = True

    start_time = fields.DateTime(required=False)
    end_time = fields.DateTime(required=False)

    @post_load
    def make_time_window(self, data, **kwargs):
        return TimeWindow(
            start_time=data.get("start_time"),
            end_time=data.get("end_time")
        )
