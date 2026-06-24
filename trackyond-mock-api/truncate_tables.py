import sys
import os
from sqlalchemy import text

# Add current directory to path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from db.database import SessionLocal

def truncate():
    db = SessionLocal()
    try:
        # We run custom raw SQL to truncate tables CASCADE
        # The tables are: message_contents, message_deleted_for_users, messages, job_activities, jobs
        db.execute(text("TRUNCATE TABLE message_contents, message_deleted_for_users, messages, job_activities, jobs CASCADE;"))
        db.commit()
        print("Job and message related tables truncated successfully!")
    except Exception as e:
        db.rollback()
        print(f"Error truncating tables: {e}")
        raise e
    finally:
        db.close()

if __name__ == "__main__":
    truncate()
