from datetime import datetime
from typing import List
from core.responses.models import BaseSchema

class NotificationBase(BaseSchema):
    notification_id: str
    message: str
    read: bool
    created_at: datetime

class NotificationListResponse(BaseSchema):
    notifications: List[NotificationBase]
