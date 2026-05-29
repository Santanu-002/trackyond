from enum import Enum

class AttendanceStatus(str, Enum):
    not_started = "not started"
    working = "working"
    ended = "ended"

    @classmethod
    def _missing_(cls, value):
        if isinstance(value, str):
            val = value.lower().replace("_", " ")
            for member in cls:
                if member.value == val:
                    return member
        return super()._missing_(value)

class UserRole(str, Enum):
    owner = "owner"
    worker = "worker"

    @classmethod
    def _missing_(cls, value):
        if isinstance(value, str):
            val = value.lower()
            if val in ["admin", "owner"]:
                return cls.owner
            if val in ["employee", "worker", "staff"]:
                return cls.worker
            for member in cls:
                if member.value == val:
                    return member
        return super()._missing_(value)

class JobStatus(str, Enum):
    pending = "pending"
    assigned = "assigned"
    in_progress = "in_progress"
    completed = "completed"
    cancelled = "cancelled"

    @classmethod
    def _missing_(cls, value):
        if isinstance(value, str):
            # Handle camelCase, PascalCase, spaces, and hyphens
            import re
            # Convert camelCase/PascalCase to snake_case
            s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', value)
            val = re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()
            # Normalize separators
            val = val.replace(" ", "_").replace("-", "_")

            for member in cls:
                if member.value == val:
                    return member
        return super()._missing_(value)

class NotificationStatus(str, Enum):
    sent = "sent"
    delivered = "delivered"
    seen = "seen"
    read = "read"

class NotificationType(str, Enum):
    job_assigned = "job_assigned"
    job_reminder = "job_reminder"
    attendance_reminder = "attendance_reminder"
    announcement = "announcement"
    system = "system"

class ChatMessageType(str, Enum):
    text = "text"
    image = "image"
    video = "video"
    docs = "docs"
    activity = "activity"
    header = "header"
    reply = "reply"