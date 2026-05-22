"""add_message_type_metadata_and_rename_content_text

Revision ID: b33a03e4102a
Revises: 73ddceb3edff
Create Date: 2026-05-22 13:31:51.315254

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'b33a03e4102a'
down_revision: Union[str, None] = '73ddceb3edff'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Add type and metadata_json to job_chat_messages
    op.add_column('job_chat_messages', sa.Column('type', sa.String(), nullable=False, server_default='message'))
    op.add_column('job_chat_messages', sa.Column('metadata_json', sa.Text(), nullable=True))
    
    # Rename message to text in job_chat_message_contents
    op.alter_column('job_chat_message_contents', 'message', new_column_name='text')


def downgrade() -> None:
    # Rename text back to message in job_chat_message_contents
    op.alter_column('job_chat_message_contents', 'text', new_column_name='message')
    
    # Drop columns from job_chat_messages
    op.drop_column('job_chat_messages', 'metadata_json')
    op.drop_column('job_chat_messages', 'type')
