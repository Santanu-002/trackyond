from sqlalchemy.orm import Session
from sqlalchemy import desc, asc
import uuid
import json
from datetime import datetime
from db import models
from schemas import job_chat as schemas
from core.utils.datetime_utils import now_utc
from core.constants.enums import ChatMessageType

def get_job_messages(db: Session, job_id: str):
    messages = db.query(models.JobChatMessage).filter(
        models.JobChatMessage.job_id == job_id,
        models.JobChatMessage.active == True
    ).order_by(asc(models.JobChatMessage.created_at)).all()
    
    # Process metadata_json to dict
    for msg in messages:
        for content in msg.contents:
            if content.metadata_json:
                content.metadata = json.loads(content.metadata_json)
            else:
                content.metadata = None
    
    return messages

def create_job_message(db: Session, job_id: str, message_data: schemas.JobChatMessageCreate):
    db_message = models.JobChatMessage(
        uid=message_data.uid or uuid.uuid4().hex,
        local_id=message_data.local_id,
        job_id=job_id,
        author_type=message_data.author_type,
        created_by_uid=message_data.created_by_uid,
        created_by_profile_uid=message_data.created_by_profile_uid,
        status=message_data.status,
        created_by_author_at=message_data.created_by_author_at
    )
    
    db.add(db_message)
    db.flush() # Get the uid if it was auto-generated
    
    for content in message_data.contents:
        db_content = models.JobChatMessageContent(
            message_uid=db_message.uid,
            type=content.type,
            message=content.message,
            metadata_json=json.dumps(content.metadata) if content.metadata else None
        )
        db.add(db_content)
    
    db.commit()
    db.refresh(db_message)
    return db_message

def create_system_activity_message(db: Session, job_id: str, text: str, message_type: ChatMessageType = ChatMessageType.activity):
    """Utility to create automated timeline activity messages"""
    message_uid = uuid.uuid4().hex
    
    db_message = models.JobChatMessage(
        uid=message_uid,
        job_id=job_id,
        author_type="system",
        status="sent",
        created_by_author_at=now_utc()
    )
    
    db.add(db_message)
    db.flush()
    
    db_content = models.JobChatMessageContent(
        message_uid=db_message.uid,
        type=message_type.value,
        message=text
    )
    db.add(db_content)
    
    db.commit()
    return db_message
