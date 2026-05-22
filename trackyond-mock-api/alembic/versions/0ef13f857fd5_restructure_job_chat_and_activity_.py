"""restructure_job_chat_and_activity_columns

Revision ID: 0ef13f857fd5
Revises: b33a03e4102a
Create Date: 2026-05-22 13:45:01.855579

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '0ef13f857fd5'
down_revision: Union[str, None] = 'b33a03e4102a'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Rename text column to content in job_chat_message_contents
    op.alter_column('job_chat_message_contents', 'text', new_column_name='content')
    
    # Update job_activities columns
    op.drop_column('job_activities', 'metadata_json')
    op.add_column('job_activities', sa.Column('lat', sa.Float(), nullable=True))
    op.add_column('job_activities', sa.Column('lon', sa.Float(), nullable=True))
    op.add_column('job_activities', sa.Column('address', sa.Text(), nullable=True))


def downgrade() -> None:
    # Drop lat, lon, address from job_activities and restore metadata_json
    op.drop_column('job_activities', 'address')
    op.drop_column('job_activities', 'lon')
    op.drop_column('job_activities', 'lat')
    op.add_column('job_activities', sa.Column('metadata_json', sa.Text(), nullable=True))
    
    # Rename content column back to text in job_chat_message_contents
    op.alter_column('job_chat_message_contents', 'content', new_column_name='text')

