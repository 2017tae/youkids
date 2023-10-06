from pydantic import BaseModel
from typing import Optional, List, Dict
import datetime

class RegionData(BaseModel):
    place_df: Optional[List[Dict]] = None
    click_df: Optional[List[Dict]] = None
    svd_preds_df: Optional[List[Dict]] = None
    update_date: Optional[datetime.date] = None
    table: Optional[str] = None  # DynamoDB 테이블을 저장할 변수