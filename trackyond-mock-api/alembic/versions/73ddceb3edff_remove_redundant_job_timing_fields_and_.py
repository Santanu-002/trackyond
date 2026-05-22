"""remove_redundant_job_timing_fields_and_create_view

Revision ID: 73ddceb3edff
Revises: 89006e95d960
Create Date: 2026-05-22 07:00:55.541944

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '73ddceb3edff'
down_revision: Union[str, None] = '89006e95d960'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Drop physical columns from the jobs table
    op.drop_column('jobs', 'assigned_at')
    op.drop_column('jobs', 'started_at')
    op.drop_column('jobs', 'completed_at')
    
    # Create the jobs_view database view
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
        (SELECT jcmc.message 
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


def downgrade() -> None:
    # Drop the database view
    op.execute("DROP VIEW IF EXISTS jobs_view;")
    
    # Re-add physical columns to the jobs table
    op.add_column('jobs', sa.Column('assigned_at', sa.DateTime(), nullable=True))
    op.add_column('jobs', sa.Column('started_at', sa.DateTime(), nullable=True))
    op.add_column('jobs', sa.Column('completed_at', sa.DateTime(), nullable=True))

