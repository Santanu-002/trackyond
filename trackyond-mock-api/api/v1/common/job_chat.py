from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List, Optional
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
    db.commit()
    
    # Broadcast to WebSocket channel so active users receive it in real-time
    try:
        from services.websocket_service import websocket_manager
        broadcast_data = {
            "message": response_data["messages"][-1] if response_data["messages"] else None,
            "messages": response_data["messages"],
            "job": response_data["job"]
        }
        await websocket_manager.broadcast_to_job(db, job_id, "chat", "received", broadcast_data)

        # Broadcast seen status for previous messages if any were marked as seen
        seen_message_uids = response_data.get("seenMessageUids", [])
        if seen_message_uids:
            from core.utils.datetime_utils import to_utc_iso
            seen_broadcast_data = {
                "jobId": job_id,
                "messageUids": seen_message_uids,
                "seenAt": to_utc_iso()
            }
            await websocket_manager.broadcast_to_job(db, job_id, "chat", "seen", seen_broadcast_data)
            
            # Send cancel notification silent FCM
            try:
                from services.notification_service import send_cancel_notification_push
                send_cancel_notification_push(db, current_user.uid, job_id)
            except Exception as e:
                print(f"Error sending cancelNotification FCM from send REST: {e}")
    except Exception as e:
        print(f"Error broadcasting REST-sent message or seen status: {e}")
        
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

@router.post("/{job_id}/seen", response_model=GenericResponse)
async def mark_messages_seen(
    job_id: str,
    payload: Optional[schemas.JobChatMessageSeenRequest] = None,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Mark unread messages in a job chat as seen by the current user.
    """
    from services import job_chat_service
    from services.websocket_service import websocket_manager
    from core.utils.datetime_utils import to_utc_iso
    
    req_message_uids = payload.message_uids if payload else None
    message_uids = job_chat_service.mark_job_messages_as_seen(
        db, job_id, current_user, message_uids=req_message_uids
    )
    
    if message_uids:
        broadcast_data = {
            "jobId": job_id,
            "messageUids": message_uids,
            "seenAt": to_utc_iso()
        }
        await websocket_manager.broadcast_to_job(db, job_id, "chat", "seen", broadcast_data)
        
        # Trigger silent cancelNotification FCM to user's other devices
        try:
            from services.notification_service import send_cancel_notification_push
            send_cancel_notification_push(db, current_user.uid, job_id)
        except Exception as e:
            print(f"Error sending cancelNotification FCM: {e}")
        
    return GenericResponse(
        success=True, 
        message=f"Marked {len(message_uids)} messages as seen",
        data={"messageUids": message_uids}
    )

@router.post("/{job_id}/delivered", response_model=GenericResponse)
async def mark_messages_delivered(
    job_id: str,
    payload: schemas.JobChatMessageDeliveredRequest,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Mark specific messages in a job chat as delivered.
    """
    from services import job_chat_service
    from services.websocket_service import websocket_manager
    from core.utils.datetime_utils import to_utc_iso
    
    delivered_uids = job_chat_service.mark_job_messages_as_delivered(db, job_id, payload.message_uids)
    
    if delivered_uids:
        broadcast_data = {
            "jobId": job_id,
            "messageUids": delivered_uids,
            "deliveredAt": to_utc_iso()
        }
        await websocket_manager.broadcast_to_job(db, job_id, "chat", "delivered", broadcast_data)
        
    return GenericResponse(success=True, message=f"Marked {len(delivered_uids)} messages as delivered")



