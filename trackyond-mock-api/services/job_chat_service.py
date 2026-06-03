from sqlalchemy.orm import Session
from sqlalchemy import desc, asc
import uuid
import json
from datetime import datetime, timezone
from fastapi import HTTPException
from db import models
from schemas import job_chat as schemas
from core.utils.datetime_utils import now_utc
from core.constants.enums import ChatMessageType, JobStatus, ChatMessageStatus
from services.serializers import serialize_job, serialize_member_profile

def get_job_messages(db: Session, job_id: str, limit: int = None, offset: int = None, search: str = None, message_type: str = None, current_user: models.User = None):
    query = db.query(models.JobChatMessage).filter(
        models.JobChatMessage.job_id == job_id,
        models.JobChatMessage.active == True
    )

    if current_user:
        deleted_uids = db.query(models.MessageDeletedForUser.message_uid).filter(
            models.MessageDeletedForUser.user_uid == current_user.uid
        )
        query = query.filter(~models.JobChatMessage.uid.in_(deleted_uids))

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
        meta_dict = db_message.metadata_dict or {}
        activity_type_meta = meta_dict.get("activityType") or db_message.action_performed
        if activity_type_meta:
            # Map activity_type_meta -> (db_activity_type, job_status_update)
            activity_map = {
                "reachedLocation": ("reached", None),
                "reached_location": ("reached", None),
                "reached": ("reached", None),
                
                "startedJob": ("started", JobStatus.in_progress),
                "started_job": ("started", JobStatus.in_progress),
                "started": ("started", JobStatus.in_progress),
                
                "completedJob": ("completed", JobStatus.completed),
                "completed_job": ("completed", JobStatus.completed),
                "completed": ("completed", JobStatus.completed),
                
                "takeBreak": ("take_break", None),
                "take_break": ("take_break", None),
                "take_started": ("take_break", None),
                
                "breakOut": ("break_out", None),
                "break_out": ("break_out", None),
                "resumed": ("break_out", None),
                
                "sendLocation": ("send_location", None),
                "send_location": ("send_location", None),
                
                "askLocation": ("ask_location", None),
                "ask_location": ("ask_location", None),
                
                "askStatus": ("ask_status", None),
                "ask_status": ("ask_status", None),
                
                "askStatusProofs": ("ask_status_proofs", None),
                "ask_status_proofs": ("ask_status_proofs", None),
                
                "sendStatus": ("send_status", None),
                "send_status": ("send_status", None),
                
                "cancelJob": ("cancel_job", None),
                "cancel_job": ("cancel_job", None),
                
                "reopenJob": ("reopen_job", None),
                "reopen_job": ("reopen_job", None),
                
                "jobCreated": ("created", None),
                "job_created": ("created", None),
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
        author_type="user" if (sender_uid and sender_uid != "system") else "system",
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

def send_job_messages(db: Session, job_id: str, messages_data: list[schemas.JobChatMessageCreate], current_user: models.User) -> dict:
    """
    Validates attendance and permissions, creates a list of messages, and returns the response data
    containing details of the messages sent, allowed actions, and the updated serialized job.
    """
    # Enforce worker attendance check before sending messages or timeline actions
    validate_worker_attendance(db, current_user)

    member = db.query(models.Member).filter(models.Member.user_uid == current_user.uid).first()
    
    # Verify authorization for all messages
    for msg_data in messages_data:
        is_system = msg_data.type == "activity" and (not msg_data.sender_uid or msg_data.sender_uid == "system")
        if not is_system:
            if not member or msg_data.sender_uid != member.uid:
                raise HTTPException(
                    status_code=403, 
                    detail=f"Unauthorized to send message as this member profile (senderUid: {msg_data.sender_uid})"
                )

    serialized_messages = []
    last_message = None
    
    for msg_data in messages_data:
        message = create_job_message(db, job_id, msg_data, current_user)
        last_message = message
        message_serialized = schemas.JobChatMessageResponse.model_validate(message).model_dump(by_alias=True)
        serialized_messages.append(message_serialized)

    # Get the updated job and serialize fully using jobs_service
    from services.jobs_service import get_job_with_details
    job = db.query(models.Job).filter(models.Job.job_id == job_id).first()
    
    serialized_job = get_job_with_details(db, job) if job else {}
    
    if job and last_message:
        try:
            from services.notification_service import send_job_chat_notification
            send_job_chat_notification(db, job, current_user, last_message, serialized_messages[-1])
        except Exception as e:
            print(f"Error triggering job chat notification: {e}")

    return {
        "messages": serialized_messages,
        "job": serialized_job
    }


def send_job_message(db: Session, job_id: str, message_data: schemas.JobChatMessageCreate, current_user: models.User) -> dict:
    """
    Validates attendance and permissions, creates a single message, and returns the response data
    containing message detail, allowed actions, and the updated serialized job.
    """
    return send_job_messages(db, job_id, [message_data], current_user)


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

def delete_job_messages(db: Session, job_id: str, delete_req: schemas.JobChatMessageDeleteRequest, current_user: models.User):
    # Fetch job first to ensure it exists
    job = db.query(models.Job).filter(models.Job.job_id == job_id).first()
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")

    is_owner = current_user.role.value == "owner"

    if delete_req.delete_type == "forMe":
        for msg_uid in delete_req.message_uids:
            msg = db.query(models.JobChatMessage).filter(models.JobChatMessage.uid == msg_uid, models.JobChatMessage.job_id == job_id).first()
            if not msg:
                raise HTTPException(status_code=404, detail=f"Message {msg_uid} not found")
            
            # Check if record already exists to avoid unique constraint violations
            exists = db.query(models.MessageDeletedForUser).filter(
                models.MessageDeletedForUser.message_uid == msg_uid,
                models.MessageDeletedForUser.user_uid == current_user.uid
            ).first()
            if not exists:
                deleted_for_me = models.MessageDeletedForUser(
                    message_uid=msg_uid,
                    user_uid=current_user.uid
                )
                db.add(deleted_for_me)
        db.commit()

    elif delete_req.delete_type == "forEveryone":
        for msg_uid in delete_req.message_uids:
            msg = db.query(models.JobChatMessage).filter(models.JobChatMessage.uid == msg_uid, models.JobChatMessage.job_id == job_id).first()
            if not msg:
                raise HTTPException(status_code=404, detail=f"Message {msg_uid} not found")
            
            # Workers validation rules
            if not is_owner:
                # 1. Activity messages cannot be deleted for everyone by workers
                if msg.type == "activity":
                    raise HTTPException(status_code=403, detail="Workers cannot delete activity messages for everyone")
                
                # 2. Worker must be the author of the message
                if msg.created_by_uid != current_user.uid:
                    raise HTTPException(status_code=403, detail="Cannot delete other user's messages for everyone")
                
                # 3. Message must have been created < 15 minutes ago
                device_time = delete_req.deleted_by_user_at
                if device_time.tzinfo is None:
                    device_time = device_time.replace(tzinfo=timezone.utc)
                else:
                    device_time = device_time.astimezone(timezone.utc)
                
                msg_time = msg.createdByAuthorAt if hasattr(msg, 'createdByAuthorAt') else msg.created_by_author_at
                if msg_time.tzinfo is None:
                    msg_time = msg_time.replace(tzinfo=timezone.utc)
                else:
                    msg_time = msg_time.astimezone(timezone.utc)
                
                diff = device_time - msg_time
                if diff.total_seconds() > 900: # 15 minutes
                    raise HTTPException(status_code=400, detail="Cannot delete messages created more than 15 minutes ago")
            
            # Perform delete for everyone (by updating status and metadata, and clearing content)
            msg.status = ChatMessageStatus.removed.value
            msg.deleted = True
            msg.deleted_by_uid = current_user.uid
            msg.deleted_by_user_type = current_user.role.value
            msg.deleted_at = now_utc()
            msg.deleted_by_user_at = delete_req.deleted_by_user_at
            
            # Clear contents for privacy
            msg.content = []
        
        db.commit()
    else:
        raise HTTPException(status_code=400, detail="Invalid delete type")

