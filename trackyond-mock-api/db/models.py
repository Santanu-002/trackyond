from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey, Float, Text, UniqueConstraint, Enum as SQLEnum
from sqlalchemy.orm import relationship
from datetime import datetime, timezone
from core.utils.datetime_utils import now_utc
from .database import Base
from core.constants.enums import UserRole, JobStatus, AttendanceStatus, NotificationStatus

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    uid = Column(String, unique=True, index=True)
    phone = Column(String, unique=True, index=True)
    role = Column(SQLEnum(UserRole), default=UserRole.worker)

    is_new_user = Column(Boolean, default=True)
    primary_profile_uid = Column(String, nullable=True) # UID of the primary Member/Profile record
    created_at = Column(DateTime, default=now_utc)
    updated_at = Column(DateTime, default=now_utc, onupdate=now_utc)

class Session(Base):
    __tablename__ = "sessions"
    id = Column(Integer, primary_key=True, index=True)
    user_uid = Column(String, ForeignKey("users.uid"))
    device_id = Column(String)
    refresh_token = Column(String, nullable=True)
    login_at = Column(DateTime, default=now_utc)
    logout_at = Column(DateTime, nullable=True)
    session_updated_at = Column(DateTime, default=now_utc)
    device_metadata = Column(Text) # JSON string

class Company(Base):
    __tablename__ = "companies"
    id = Column(Integer, primary_key=True, index=True)
    company_id = Column(String, unique=True, index=True)
    name = Column(String)
    owner_uid = Column(String, ForeignKey("users.uid"), unique=True, nullable=False)
    team_size = Column(Integer)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))

class Member(Base):
    __tablename__ = "members"
    id = Column(Integer, primary_key=True, index=True)
    uid = Column(String, unique=True, index=True) # Unique ID for this membership/profile
    user_uid = Column(String, ForeignKey("users.uid"), index=True, nullable=False) # UID of the user account
    name = Column(String, nullable=False)
    phone = Column(String, index=True, nullable=False)
    designation = Column(String, nullable=False)
    image = Column(String, nullable=True)
    gender = Column(String, nullable=True)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc), nullable=False)
    
    # New fields for multi-tenancy and creator tracking
    created_by = Column(String, ForeignKey("users.uid"), nullable=True)
    company_uid = Column(String, ForeignKey("companies.company_id"), nullable=False)
    is_active = Column(Boolean, default=True, nullable=False)

    __table_args__ = (
        UniqueConstraint('user_uid', 'company_uid', name='_user_company_uc'),
    )

class Job(Base):
    __tablename__ = "jobs"
    id = Column(Integer, primary_key=True, index=True)
    job_id = Column(String, unique=True, index=True)
    title = Column(String)
    customer_name = Column(String)
    customer_phone = Column(String, nullable=False)
    customer_address = Column(String, nullable=True)
    worker_profile_uid = Column(String, ForeignKey("members.uid"), nullable=False)
    company_uid = Column(String, ForeignKey("companies.company_id"), index=True)
    created_by = Column(String, ForeignKey("users.uid"))
    created_by_profile_uid = Column(String, ForeignKey("members.uid"), nullable=True)
    status = Column(SQLEnum(JobStatus), default=JobStatus.pending)

    require_photo_on_start = Column(Boolean, default=False, nullable=False)
    require_photo_on_complete = Column(Boolean, default=False, nullable=False)
    capture_location = Column(Boolean, default=True, nullable=False)
    created_at = Column(DateTime, default=now_utc)
    assigned_at = Column(DateTime, nullable=True)
    started_at = Column(DateTime, nullable=True)
    updated_at = Column(DateTime, default=now_utc, onupdate=now_utc)
    completed_at = Column(DateTime, nullable=True)

class Notification(Base):
    __tablename__ = "notifications"
    id = Column(Integer, primary_key=True, index=True)
    notification_id = Column(String, unique=True, index=True)
    user_uid = Column(String, ForeignKey("users.uid"), nullable=False)
    profile_uid = Column(String, ForeignKey("members.uid"), index=True, nullable=False) # Member.uid
    title = Column(String, nullable=True)
    body = Column(Text, nullable=False)
    data_payload = Column(Text, nullable=True) # JSON string
    status = Column(SQLEnum(NotificationStatus), default=NotificationStatus.sent, nullable=False)
    read = Column(Boolean, default=False)
    seen = Column(Boolean, default=False)
    deleted = Column(Boolean, default=False)
    deleted_at = Column(DateTime, nullable=True)
    deleted_by = Column(String, ForeignKey("members.uid"), nullable=True)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    updated_at = Column(DateTime, default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))
    delivered_at = Column(DateTime, nullable=True)
    seen_at = Column(DateTime, nullable=True)

class FCMToken(Base):
    __tablename__ = "fcm_tokens"
    id = Column(Integer, primary_key=True, index=True)
    user_uid = Column(String, ForeignKey("users.uid"), index=True, nullable=False)
    profile_uid = Column(String, nullable=True)
    device_id = Column(String, index=True, nullable=False)
    fcm_token = Column(String, nullable=False)
    user_role = Column(SQLEnum(UserRole), nullable=False)
    platform = Column(String, nullable=True) # android, ios, etc
    app_version = Column(String, nullable=True)
    is_active = Column(Boolean, default=True, nullable=False)
    
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    updated_at = Column(DateTime, default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))

    __table_args__ = (
        UniqueConstraint('user_uid', 'device_id', name='_user_device_fcm_uc'),
    )

class Attendance(Base):
    __tablename__ = "attendance"
    id = Column(Integer, primary_key=True, index=True)
    profile_uid = Column(String, ForeignKey("members.uid"))
    user_uid = Column(String, index=True) # Derived/Saved for convenience
    company_uid = Column(String, index=True) # Derived/Saved for convenience
    
    start_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    end_at = Column(DateTime, nullable=True)
    
    start_latitude = Column(Float)
    start_longitude = Column(Float)
    end_latitude = Column(Float, nullable=True)
    end_longitude = Column(Float, nullable=True)
    
    work_hours = Column(Float, nullable=True) # Derived on end
    
    start_address = Column(String, nullable=True)
    end_address = Column(String, nullable=True)
    
    # Status: not started | working | ended
    status = Column(SQLEnum(AttendanceStatus), default=AttendanceStatus.not_started)
    
    created_at = Column(DateTime, default=now_utc)
    updated_at = Column(DateTime, default=now_utc, onupdate=now_utc)

class JobChatMessage(Base):
    __tablename__ = "job_chat_messages"
    uid = Column(String, primary_key=True, index=True)
    local_id = Column(String, nullable=True) # ID generated by mobile client
    job_id = Column(String, ForeignKey("jobs.job_id"), index=True)
    
    # Author Info
    created_by_uid = Column(String, ForeignKey("users.uid"), nullable=True) # Null for System
    created_by_profile_uid = Column(String, ForeignKey("members.uid"), nullable=True)
    author_type = Column(String, default="user") # 'user' or 'system'
    
    # Timing
    created_at = Column(DateTime, default=now_utc)
    updated_at = Column(DateTime, default=now_utc, onupdate=now_utc)
    created_by_author_at = Column(DateTime) # Device timestamp
    
    # Status
    status = Column(String, default="sent") # 'sent', 'delivered', 'seen'
    seen_at = Column(DateTime, nullable=True)
    delivered_at = Column(DateTime, nullable=True)
    active = Column(Boolean, default=True)
    deleted = Column(Boolean, default=False)

    contents = relationship("JobChatMessageContent", back_populates="chat_message", cascade="all, delete-orphan")

class JobChatMessageContent(Base):
    __tablename__ = "job_chat_message_contents"
    id = Column(Integer, primary_key=True, index=True)
    message_uid = Column(String, ForeignKey("job_chat_messages.uid"))
    
    # Content Type: text, image, video, docs, activity
    type = Column(String, nullable=False)
    message = Column(Text, nullable=True) # Text content or caption
    
    # Metadata stored as JSON
    metadata_json = Column(Text, nullable=True) 

    chat_message = relationship("JobChatMessage", back_populates="contents")
