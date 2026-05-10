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
            val = value.lower().replace(" ", "_")
            for member in cls:
                if member.value == val:
                    return member
        return super()._missing_(value)