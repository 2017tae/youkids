from pydantic import BaseModel
from typing import Optional

class PlaceItem(BaseModel):
    place_id: int
    name: str
    address: str
    category: str
    image_url: Optional[str]