from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from db.database import get_db
from db import models
from api.dependencies import get_current_user
from services import job_chat_service
from schemas import job_chat as schemas
from core.responses.models import GenericResponse

router = APIRouter(prefix="/job-chat", tags=["Job Chat"])

@router.get("/{job_id}/messages", response_model=GenericResponse)
async def get_messages(
    job_id: str,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Get all messages for a specific job chat.
    """
    messages = job_chat_service.get_job_messages(db, job_id)
    # Serialize using Pydantic schema
    messages_data = [schemas.JobChatMessageResponse.model_validate(m).model_dump(by_alias=True) for m in messages]
    return GenericResponse(success=True, message="Messages fetched successfully", data=messages_data)

from services.serializers import serialize_job

@router.post("/{job_id}/messages", response_model=GenericResponse)
async def send_message(
    job_id: str,
    message_data: schemas.JobChatMessageCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Send a new message to a job chat.
    """
    if message_data.author_type != "system" and message_data.created_by_uid != current_user.uid:
        print(f"[DEBUG 403] message_data.author_type={message_data.author_type}")
        print(f"[DEBUG 403] message_data.created_by_uid={message_data.created_by_uid}")
        print(f"[DEBUG 403] current_user.uid={current_user.uid}")
        raise HTTPException(status_code=403, detail=f"Unauthorized to send message as this user (created_by_uid: {message_data.created_by_uid}, current_user.uid: {current_user.uid})")
        
    message = job_chat_service.create_job_message(db, job_id, message_data)
    message_serialized = schemas.JobChatMessageResponse.model_validate(message).model_dump(by_alias=True)
    
    # Get the updated allowed actions for this job (since status/reached event might change them)
    job = db.query(models.Job).filter(models.Job.job_id == job_id).first()
    serialized_job = serialize_job(job, db=db) if job else {}
    allowed_actions = serialized_job.get("allowedActions", []) if serialized_job else []
    
    response_data = {
        "message": message_serialized,
        "allowedActions": allowed_actions
    }
    return GenericResponse(success=True, message="Message sent successfully", data=response_data)
