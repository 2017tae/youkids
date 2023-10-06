from pydantic import BaseModel
import datetime

class FestivalItem(BaseModel):
    festival_child_id: int
    each_id: str
    name: str
    start_date: datetime.date
    end_date: datetime.date
    state: str
    category: str
    open_run: str
    poster: str
    place_name: str