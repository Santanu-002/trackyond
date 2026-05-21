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

def get_job_messages(db: Session, job_id: str):
    messages = db.query(models.JobChatMessage).filter(
        models.JobChatMessage.job_id == job_id,
        models.JobChatMessage.active == True
    ).order_by(asc(models.JobChatMessage.created_at)).all()
    
    return messages

def create_job_message(db: Session, job_id: str, message_data: schemas.JobChatMessageCreate):
    db_message = models.JobChatMessage(
        uid=uuid.uuid4().hex,
        local_id=message_data.local_id,
        job_id=job_id,
        author_type=message_data.author_type,
        created_by_uid=message_data.created_by_uid,
        created_by_profile_uid=message_data.created_by_profile_uid,
        status=message_data.status,
        created_by_author_at=message_data.created_by_author_at
    )

    db.add(db_message)
    db.flush()

    for content in message_data.contents:
        db_content = models.JobChatMessageContent(
            message_uid=db_message.uid,
            type=content.type,
            message=content.message
        )
        if hasattr(content, "metadata") and content.metadata is not None:
            db_content.metadata_dict = content.metadata
        db.add(db_content)

        # Only process activity actions when explicitly provided via actionPerformed
        action = (content.action_performed or "").lower().strip() if content.type == "activity" else ""

        if not action:
            continue

        # Map action keyword -> (activity_type, job status transition)
        action_map = {
            "reached": ("reached", None),
            "start_job": ("started", JobStatus.in_progress),
            "complete_job": ("completed", JobStatus.completed),
        }

        if action not in action_map:
            continue

        activity_type, job_status_update = action_map[action]

        job = db.query(models.Job).filter(models.Job.job_id == job_id).first()
        if job:
            if job_status_update:
                job.status = job_status_update
                if job_status_update == JobStatus.in_progress and not job.started_at:
                    job.started_at = now_utc()
                if job_status_update == JobStatus.completed and not job.completed_at:
                    job.completed_at = now_utc()
            job.updated_at = now_utc()

        # Record in Activity History
        import json
        db_activity = models.JobActivity(
            uid=uuid.uuid4().hex,
            job_id=job_id,
            profile_uid=message_data.created_by_profile_uid,
            actor_type=message_data.author_type,
            activity_type=activity_type,
            message=content.message,
            metadata_json=json.dumps(content.metadata) if hasattr(content, "metadata") and content.metadata is not None else None
        )
        db.add(db_activity)

        # Add a system timeline bubble so the chat shows the activity entry
        timeline_uid = uuid.uuid4().hex
        timeline_msg = models.JobChatMessage(
            uid=timeline_uid,
            job_id=job_id,
            author_type="system",
            status="sent",
            created_by_author_at=now_utc()
        )
        db.add(timeline_msg)
        db.flush()

        timeline_labels = {
            "reached": f"@[profileUid#{message_data.created_by_profile_uid}] has reached the job site",
            "started": f"@[profileUid#{message_data.created_by_profile_uid}] has started the job",
            "completed": f"@[profileUid#{message_data.created_by_profile_uid}] has completed the job",
        }
        timeline_text = timeline_labels.get(activity_type, f"Activity recorded: {activity_type}")

        db_timeline_content = models.JobChatMessageContent(
            message_uid=timeline_uid,
            type=ChatMessageType.activity.value,
            message=timeline_text
        )
        db.add(db_timeline_content)

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

    if message_data.author_type != "system" and message_data.created_by_uid != current_user.uid:
        raise HTTPException(
            status_code=403, 
            detail=f"Unauthorized to send message as this user (created_by_uid: {message_data.created_by_uid}, current_user.uid: {current_user.uid})"
        )
        
    message = create_job_message(db, job_id, message_data)
    message_serialized = schemas.JobChatMessageResponse.model_validate(message).model_dump(by_alias=True)
    
    # Get the updated job and serialize fully using jobs_service
    from services.jobs_service import get_job_with_details
    job = db.query(models.Job).filter(models.Job.job_id == job_id).first()
    
    serialized_job = get_job_with_details(db, job) if job else {}
    allowed_actions = serialized_job.get("allowedActions", []) if serialized_job else []
    
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

