from sqlalchemy.orm import Session
from sqlalchemy import desc, asc
import uuid
import json
from datetime import datetime
from fastapi import HTTPException
from db import models
from schemas import job_chat as schemas
from core.utils.datetime_utils import now_utc
from core.constants.enums import ChatMessageType, JobStatus
from services.serializers import serialize_job, serialize_member_profile

def get_job_messages(db: Session, job_id: str, limit: int = None, offset: int = None, search: str = None, message_type: str = None):
    query = db.query(models.JobChatMessage).filter(
        models.JobChatMessage.job_id == job_id,
        models.JobChatMessage.active == True
    )

    if message_type:
        query = query.filter(models.JobChatMessage.type == message_type)

    if search:
        query = query.filter(models.JobChatMessage.content.any(
            models.JobChatMessageContent.content.ilike(f"%{search}%")
        ))

    if limit is not None or offset is not None:
        query = query.order_by(desc(models.JobChatMessage.created_at))
        if offset is not None:
            query = query.offset(offset)
        if limit is not None:
            query = query.limit(limit)
        messages = query.all()
        messages.reverse()
        return messages
    else:
        return query.order_by(asc(models.JobChatMessage.created_at)).all()

def create_job_message(db: Session, job_id: str, message_data: schemas.JobChatMessageCreate, current_user: models.User = None):
    print("DEBUG: message_data.created_by_author_at =", message_data.created_by_author_at, type(message_data.created_by_author_at))
    is_system = message_data.type == "activity" and (not message_data.sender_uid or message_data.sender_uid == "system")
    author_type = "system" if is_system else "user"
    
    created_by_uid = None
    if not is_system and current_user:
        created_by_uid = current_user.uid

    msg_uid = uuid.uuid4().hex
    msg_local_id = msg_uid if is_system else message_data.local_id

    db_message = models.JobChatMessage(
        uid=msg_uid,
        local_id=msg_local_id,
        job_id=job_id,
        author_type=author_type,
        created_by_uid=created_by_uid,
        sender_uid=message_data.sender_uid,
        status="sent",
        created_by_author_at=message_data.created_by_author_at,
        type=message_data.type,
        action_performed=message_data.action_performed
    )
    if hasattr(message_data, "metadata") and message_data.metadata is not None:
        db_message.metadata_dict = message_data.metadata

    db.add(db_message)
    db.flush()

    for idx, content in enumerate(message_data.content):
        db_content = models.JobChatMessageContent(
            message_uid=db_message.uid,
            type=content.type,
            content=content.content
        )
        if hasattr(content, "metadata") and content.metadata is not None:
            db_content.metadata_dict = content.metadata
        db.add(db_content)

    # Process activity action if the message type is activity
    if db_message.type == "activity":
        activity_type_meta = (db_message.metadata_dict or {}).get("activity_type") or db_message.action_performed
        if activity_type_meta:
            # Map activity_type_meta -> (db_activity_type, job_status_update)
            activity_map = {
                "reachedLocation": ("reached", None),
                "startedJob": ("started", JobStatus.in_progress),
                "completedJob": ("completed", JobStatus.completed),
                "takeBreak": ("take_break", None),
                "breakOut": ("break_out", None),
                "sendLocation": ("send_location", None),
            }
            if activity_type_meta in activity_map:
                db_activity_type, job_status_update = activity_map[activity_type_meta]
                
                # Update job status
                job = db.query(models.Job).filter(models.Job.job_id == job_id).first()
                if job:
                    if job_status_update:
                        job.status = job_status_update
                    job.updated_at = now_utc()
                
                # Extract first content's text for activity message, if any
                first_text = ""
                if message_data.content:
                    first_text = message_data.content[0].content or ""

                # Record in Activity History
                db_activity = models.JobActivity(
                    uid=uuid.uuid4().hex,
                    job_id=job_id,
                    profile_uid=message_data.sender_uid,
                    actor_type=author_type,
                    activity_type=db_activity_type,
                    message=first_text,
                    lat=db_message.metadata_dict.get('latitude') if db_message.metadata_dict else None,
                    lon=db_message.metadata_dict.get('longitude') if db_message.metadata_dict else None,
                    address=db_message.metadata_dict.get('address') if db_message.metadata_dict else None
                )
                db.add(db_activity)

    db.commit()
    db.refresh(db_message)
    return db_message

def create_system_activity_message(
    db: Session, 
    job_id: str, 
    text: str, 
    message_type: ChatMessageType = ChatMessageType.activity,
    created_by_uid: str = None,
    sender_uid: str = None,
    metadata: dict = None
):
    """Utility to create automated timeline activity messages"""
    message_uid = uuid.uuid4().hex
    
    db_message = models.JobChatMessage(
        uid=message_uid,
        local_id=message_uid,
        job_id=job_id,
        author_type="system",
        created_by_uid=created_by_uid,
        sender_uid=sender_uid,
        status="sent",
        type="activity",
        created_by_author_at=now_utc()
    )
    if metadata:
        db_message.metadata_dict = metadata
    
    db.add(db_message)
    db.flush()
    
    db_content = models.JobChatMessageContent(
        message_uid=db_message.uid,
        type=message_type.value,
        content=text
    )
    db.add(db_content)
    
    db.commit()
    return db_message

def validate_worker_attendance(db: Session, current_user: models.User) -> None:
    """Enforces that a worker has marked attendance (status = 'working' active session today) before posting messages/activities."""
    if current_user.role == "worker":
        member = db.query(models.Member).filter(models.Member.user_uid == current_user.uid).first()
        if not member:
            raise HTTPException(status_code=400, detail="Member profile not found for current worker.")
        
        today_start = now_utc().replace(hour=0, minute=0, second=0, microsecond=0)
        attendance = db.query(models.Attendance).filter(
            models.Attendance.profile_uid == member.uid,
            models.Attendance.status == "working",
            models.Attendance.created_at >= today_start
        ).first()
        if not attendance:
            raise HTTPException(
                status_code=400,
                detail="You must mark your attendance (check-in) first before sending messages or performing job activities."
            )

def send_job_message(db: Session, job_id: str, message_data: schemas.JobChatMessageCreate, current_user: models.User) -> dict:
    """
    Validates attendance and permissions, creates the message, and returns the response data
    containing message detail, allowed actions, and the updated serialized job.
    """
    # Enforce worker attendance check before sending messages or timeline actions
    validate_worker_attendance(db, current_user)

    is_system = message_data.type == "activity" and (not message_data.sender_uid or message_data.sender_uid == "system")
    if not is_system:
        member = db.query(models.Member).filter(models.Member.user_uid == current_user.uid).first()
        if not member or message_data.sender_uid != member.uid:
            raise HTTPException(
                status_code=403, 
                detail=f"Unauthorized to send message as this member profile (senderUid: {message_data.sender_uid})"
            )
        
    message = create_job_message(db, job_id, message_data, current_user)
    message_serialized = schemas.JobChatMessageResponse.model_validate(message).model_dump(by_alias=True)
    
    # Get the updated job and serialize fully using jobs_service
    from services.jobs_service import get_job_with_details
    job = db.query(models.Job).filter(models.Job.job_id == job_id).first()
    
    serialized_job = get_job_with_details(db, job) if job else {}
    allowed_actions = serialized_job.get("allowedActions", []) if serialized_job else []
    
    if job:
        try:
            from services.notification_service import send_job_chat_notification
            send_job_chat_notification(db, job, current_user, message, message_serialized)
        except Exception as e:
            print(f"Error triggering job chat notification: {e}")

    return {
        "message": message_serialized,
        "allowedActions": allowed_actions,
        "job": serialized_job
    }


def get_job_chat_members(db: Session, job_id: str) -> list:
    """Gets member profiles associated with a job chat (assigner and assignee)."""
    job = db.query(models.Job).filter(models.Job.job_id == job_id).first()
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")

    members = []
    
    # 1. Fetch Assigner/Creator Profile
    if job.created_by_profile_uid:
        assigner = db.query(models.Member).filter(models.Member.uid == job.created_by_profile_uid).first()
        if assigner:
            members.append(serialize_member_profile(assigner))
            
    # 2. Fetch Assignee/Worker Profile
    if job.worker_profile_uid:
        assignee = db.query(models.Member).filter(models.Member.uid == job.worker_profile_uid).first()
        if assignee:
            # Avoid duplicate if assigner and assignee are the same
            if assignee.uid not in [m["uid"] for m in members]:
                members.append(serialize_member_profile(assignee))

    return members

