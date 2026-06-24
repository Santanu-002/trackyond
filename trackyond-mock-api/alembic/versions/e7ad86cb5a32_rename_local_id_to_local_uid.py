"""rename local_id to local_uid

Revision ID: e7ad86cb5a32
Revises: 44e8289d42dc
Create Date: 2026-06-24 08:25:00.401981

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'e7ad86cb5a32'
down_revision: Union[str, None] = '44e8289d42dc'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Rename local_id to local_uid on messages table
    op.alter_column('messages', 'local_id', new_column_name='local_uid')


def downgrade() -> None:
    # Rename local_uid back to local_id
    op.alter_column('messages', 'local_uid', new_column_name='local_id')
