from enum import Enum

class AttendanceStatus(str, Enum):
    NOT_STARTED = "not started"
    WORKING = "working"
    ENDED = "ended"
