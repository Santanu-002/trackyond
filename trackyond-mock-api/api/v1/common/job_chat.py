from fastapi import APIRouter, Depends
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
    limit: int = None,
    offset: int = None,
    search: str = None,
    type: str = None,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Get all messages for a specific job chat with optional pagination and filters.
    """
    messages = job_chat_service.get_job_messages(
        db, job_id, limit=limit, offset=offset, search=search, message_type=type, current_user=current_user
    )
    messages_data = [schemas.JobChatMessageResponse.model_validate(m).model_dump(by_alias=True) for m in messages]
    return GenericResponse(success=True, message="Messages fetched successfully", data=messages_data)

@router.post("/{job_id}/messages", response_model=GenericResponse)
async def send_message(
    job_id: str,
    messages_data: List[schemas.JobChatMessageCreate],
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Send new messages to a job chat.
    """
    response_data = job_chat_service.send_job_messages(db, job_id, messages_data, current_user)
    return GenericResponse(success=True, message="Messages sent successfully", data=response_data)

@router.get("/{job_id}/members", response_model=GenericResponse)
async def get_chat_members(
    job_id: str,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Get the profiles of members associated with this job chat (assigner and assignee).
    """
    members = job_chat_service.get_job_chat_members(db, job_id)
    return GenericResponse(success=True, message="Members fetched successfully", data=members)

@router.post("/{job_id}/messages/delete", response_model=GenericResponse)
async def delete_messages(
    job_id: str,
    delete_req: schemas.JobChatMessageDeleteRequest,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Delete messages for a job chat (delete for me / delete for everyone).
    """
    job_chat_service.delete_job_messages(db, job_id, delete_req, current_user)
    return GenericResponse(success=True, message="Messages deleted successfully")


