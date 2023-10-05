from pydantic import BaseModel
from typing import Optional

class PlaceItem(BaseModel):
    place_id: int
    name: str
    address: str
    category: str
    visited_review_num: int
    image_url: Optional[str]