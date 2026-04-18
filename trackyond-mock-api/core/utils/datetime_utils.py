from datetime import datetime, timezone

def now_utc() -> datetime:
    """Returns a timezone-aware UTC datetime object."""
    return datetime.now(timezone.utc)

def to_utc_iso(dt: datetime = None) -> str:
    """
    Standard helper to convert a datetime object (or current time) 
    to a UTC ISO 8601 string with the 'Z' suffix.
    """
    if dt is None:
        dt = now_utc()
    
    # Ensure it's in UTC if it has tzinfo, otherwise assume it's UTC
    if dt.tzinfo is not None:
        dt = dt.astimezone(timezone.utc)
    else:
        # Fallback for naive objects: assume they are UTC
        dt = dt.replace(tzinfo=timezone.utc)
        
    return dt.isoformat().replace("+00:00", "") + "Z"
