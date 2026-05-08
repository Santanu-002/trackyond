from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey, Float, Text, UniqueConstraint
from sqlalchemy.orm import relationship
from datetime import datetime, timezone
from core.utils.datetime_utils import now_utc
from .database import Base

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    uid = Column(String, unique=True, index=True)
    phone = Column(String, unique=True, index=True)
    role = Column(String) # admin | employee
    is_new_user = Column(Boolean, default=True)
    primary_account_uid = Column(String, nullable=True) # UID of the primary Member/Profile record
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
    account_uid = Column(String, unique=True, index=True) # Unique ID for this membership/profile
    user_uid = Column(String, ForeignKey("users.uid"), index=True) # UID of the user account
    name = Column(String)
    phone = Column(String, index=True)
    designation = Column(String)
    image = Column(String, nullable=True)
    gender = Column(String, nullable=True)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    
    # New fields for multi-tenancy and creator tracking
    created_by = Column(String, ForeignKey("users.uid"), nullable=True)
    company_uid = Column(String, ForeignKey("companies.company_id"), nullable=False)
    is_active = Column(Boolean, default=True)

    __table_args__ = (
        UniqueConstraint('user_uid', 'company_uid', name='_user_company_uc'),
    )

class Job(Base):
    __tablename__ = "jobs"
    id = Column(Integer, primary_key=True, index=True)
    job_id = Column(String, unique=True, index=True)
    title = Column(String)
    customer_name = Column(String)
    customer_phone = Column(String)
    customer_address = Column(String, nullable=True)
    worker_account_uid = Column(String, ForeignKey("members.account_uid"), nullable=True)
    company_uid = Column(String, ForeignKey("companies.company_id"), index=True)
    created_by = Column(String, ForeignKey("users.uid"))
    status = Column(String, default="pending") # pending | assigned | in_progress | completed
    require_photo_on_start = Column(Boolean, default=False)
    require_photo_on_complete = Column(Boolean, default=False)
    capture_location = Column(Boolean, default=False)
    created_at = Column(DateTime, default=now_utc)
    assigned_at = Column(DateTime, nullable=True)

class Notification(Base):
    __tablename__ = "notifications"
    id = Column(Integer, primary_key=True, index=True)
    notification_id = Column(String, unique=True, index=True)
    user_uid = Column(String, ForeignKey("users.uid"))
    message = Column(String)
    read = Column(Boolean, default=False)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))

class Attendance(Base):
    __tablename__ = "attendance"
    id = Column(Integer, primary_key=True, index=True)
    account_uid = Column(String, ForeignKey("members.account_uid"))
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
    status = Column(String, default="not started") 
    
    created_at = Column(DateTime, default=now_utc)
    updated_at = Column(DateTime, default=now_utc, onupdate=now_utc)

