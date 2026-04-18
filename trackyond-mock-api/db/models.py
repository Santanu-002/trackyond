from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey, Float
from sqlalchemy.orm import relationship
from datetime import datetime
from .database import Base

class Company(Base):
    __tablename__ = "companies"
    id = Column(Integer, primary_key=True, index=True)
    company_id = Column(String, unique=True, index=True)
    name = Column(String)
    user_phone_no = Column(String)
    user_full_name = Column(String)
    team_size = Column(Integer)
    created_at = Column(DateTime, default=datetime.utcnow)

class Member(Base):
    __tablename__ = "members"
    id = Column(Integer, primary_key=True, index=True)
    uid = Column(String, unique=True, index=True)
    name = Column(String)
    phone = Column(String, unique=True, index=True)
    designation = Column(String)
    image = Column(String, nullable=True)
    gender = Column(String)
    created_at = Column(DateTime, default=datetime.utcnow)

class Job(Base):
    __tablename__ = "jobs"
    id = Column(Integer, primary_key=True, index=True)
    job_id = Column(String, unique=True, index=True)
    title = Column(String)
    description = Column(String)
    customer_name = Column(String)
    customer_phone = Column(String)
    customer_address = Column(String)
    worker_uid = Column(String, ForeignKey("members.uid"))
    status = Column(String, default="pending") # pending | assigned | in_progress | completed
    require_photo_on_start = Column(Boolean, default=False)
    require_photo_on_complete = Column(Boolean, default=False)
    capture_location = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    assigned_at = Column(DateTime, nullable=True)

class Notification(Base):
    __tablename__ = "notifications"
    id = Column(Integer, primary_key=True, index=True)
    notification_id = Column(String, unique=True, index=True)
    user_uid = Column(String)
    message = Column(String)
    read = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)

class Attendance(Base):
    __tablename__ = "attendance"
    id = Column(Integer, primary_key=True, index=True)
    member_uid = Column(String)
    latitude = Column(Float)
    longitude = Column(Float)
    type = Column(String) # start | end
    marked_at = Column(DateTime, default=datetime.utcnow)
