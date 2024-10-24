from dataclasses import dataclass
from datetime import datetime

from src.extensions import WireSchema, fields
from src.extensions.db import DBMapped, db_mapped_column, DBDateTime


@dataclass(frozen=True)
class TimeWindow:
    start_time: DBMapped[datetime] = db_mapped_column(DBDateTime, nullable=True)
    end_time: DBMapped[datetime] = db_mapped_column(DBDateTime, nullable=True)

    def __repr__(self):
        return f"<TimeWindow start: {self.start_time}, end: {self.end_time}>"


class TimeWindowSchema(WireSchema):
    start_time = fields.DateTime(required=False)
    end_time = fields.DateTime(required=False)

    class Meta:
        # No model mapping is needed here because TimeWindow is a composite, not a full SQLAlchemy model
        ordered = True
