"""rename_job_chat_tables_to_messages

Revision ID: d413cad14fd5
Revises: 0ef13f857fd5
Create Date: 2026-05-29 07:57:26.624539

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'd413cad14fd5'
down_revision: Union[str, None] = '0ef13f857fd5'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # 1. Drop existing view to prevent dependency errors during table rename
    op.execute("DROP VIEW IF EXISTS jobs_view;")

    # 2. Rename tables
    op.rename_table('job_chat_messages', 'messages')
    op.rename_table('job_chat_message_contents', 'message_contents')

    # 3. Rename indexes to match new table names
    op.execute("ALTER INDEX ix_job_chat_messages_job_id RENAME TO ix_messages_job_id;")
    op.execute("ALTER INDEX ix_job_chat_messages_uid RENAME TO ix_messages_uid;")
    op.execute("ALTER INDEX ix_job_chat_message_contents_id RENAME TO ix_message_contents_id;")

    # 4. Recreate the jobs_view referencing the new tables
    op.execute("""
    CREATE OR REPLACE VIEW jobs_view AS
    SELECT 
        j.id,
        j.job_id,
        j.title,
        j.customer_name,
        j.customer_phone,
        j.customer_address,
        j.worker_profile_uid,
        j.company_uid,
        j.created_by,
        j.created_by_profile_uid,
        j.status,
        j.require_photo_on_start,
        j.require_photo_on_complete,
        j.capture_location,
        j.created_at,
        j.updated_at,
        COALESCE(
            (SELECT ja.created_at FROM job_activities ja WHERE ja.job_id = j.job_id AND ja.activity_type = 'created' ORDER BY ja.created_at ASC LIMIT 1),
            j.created_at
        ) AS assigned_at,
        (SELECT ja.created_at FROM job_activities ja WHERE ja.job_id = j.job_id AND ja.activity_type = 'started' ORDER BY ja.created_at ASC LIMIT 1) AS started_at,
        (SELECT ja.created_at FROM job_activities ja WHERE ja.job_id = j.job_id AND ja.activity_type = 'completed' ORDER BY ja.created_at ASC LIMIT 1) AS completed_at,
        (SELECT jcmc.content 
         FROM messages jcm 
         JOIN message_contents jcmc ON jcmc.message_uid = jcm.uid 
         WHERE jcm.job_id = j.job_id AND jcm.deleted = false 
         ORDER BY jcm.created_at DESC 
         LIMIT 1) AS last_message,
        (SELECT jcm.created_at 
         FROM messages jcm 
         WHERE jcm.job_id = j.job_id AND jcm.deleted = false 
         ORDER BY jcm.created_at DESC 
         LIMIT 1) AS last_message_at,
        (SELECT ja.activity_type FROM job_activities ja WHERE ja.job_id = j.job_id ORDER BY ja.created_at DESC LIMIT 1) AS last_activity_type,
        (SELECT ja.message FROM job_activities ja WHERE ja.job_id = j.job_id ORDER BY ja.created_at DESC LIMIT 1) AS last_activity_message,
        (SELECT ja.created_at FROM job_activities ja WHERE ja.job_id = j.job_id ORDER BY ja.created_at DESC LIMIT 1) AS last_activity_at
    FROM jobs j;
    """)


def downgrade() -> None:
    # 1. Drop existing view to prevent dependency errors during table rename
    op.execute("DROP VIEW IF EXISTS jobs_view;")

    # 2. Rename tables back
    op.rename_table('messages', 'job_chat_messages')
    op.rename_table('message_contents', 'job_chat_message_contents')

    # 3. Rename indexes back to old names
    op.execute("ALTER INDEX ix_messages_job_id RENAME TO ix_job_chat_messages_job_id;")
    op.execute("ALTER INDEX ix_messages_uid RENAME TO ix_job_chat_messages_uid;")
    op.execute("ALTER INDEX ix_message_contents_id RENAME TO ix_job_chat_message_contents_id;")

    # 4. Recreate the jobs_view referencing the old tables
    op.execute("""
    CREATE OR REPLACE VIEW jobs_view AS
    SELECT 
        j.id,
        j.job_id,
        j.title,
        j.customer_name,
        j.customer_phone,
        j.customer_address,
        j.worker_profile_uid,
        j.company_uid,
        j.created_by,
        j.created_by_profile_uid,
        j.status,
        j.require_photo_on_start,
        j.require_photo_on_complete,
        j.capture_location,
        j.created_at,
        j.updated_at,
        COALESCE(
            (SELECT ja.created_at FROM job_activities ja WHERE ja.job_id = j.job_id AND ja.activity_type = 'created' ORDER BY ja.created_at ASC LIMIT 1),
            j.created_at
        ) AS assigned_at,
        (SELECT ja.created_at FROM job_activities ja WHERE ja.job_id = j.job_id AND ja.activity_type = 'started' ORDER BY ja.created_at ASC LIMIT 1) AS started_at,
        (SELECT ja.created_at FROM job_activities ja WHERE ja.job_id = j.job_id AND ja.activity_type = 'completed' ORDER BY ja.created_at ASC LIMIT 1) AS completed_at,
        (SELECT jcmc.content 
         FROM job_chat_messages jcm 
         JOIN job_chat_message_contents jcmc ON jcmc.message_uid = jcm.uid 
         WHERE jcm.job_id = j.job_id AND jcm.deleted = false 
         ORDER BY jcm.created_at DESC 
         LIMIT 1) AS last_message,
        (SELECT jcm.created_at 
         FROM job_chat_messages jcm 
         WHERE jcm.job_id = j.job_id AND jcm.deleted = false 
         ORDER BY jcm.created_at DESC 
         LIMIT 1) AS last_message_at,
        (SELECT ja.activity_type FROM job_activities ja WHERE ja.job_id = j.job_id ORDER BY ja.created_at DESC LIMIT 1) AS last_activity_type,
        (SELECT ja.message FROM job_activities ja WHERE ja.job_id = j.job_id ORDER BY ja.created_at DESC LIMIT 1) AS last_activity_message,
        (SELECT ja.created_at FROM job_activities ja WHERE ja.job_id = j.job_id ORDER BY ja.created_at DESC LIMIT 1) AS last_activity_at
    FROM jobs j;
    """)
