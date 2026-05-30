"""add_action_performed_column

Revision ID: 0e8bf552ae18
Revises: d413cad14fd5
Create Date: 2026-05-30 17:34:37.793770

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '0e8bf552ae18'
down_revision: Union[str, None] = 'd413cad14fd5'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.add_column('messages', sa.Column('action_performed', sa.String(), nullable=True))


def downgrade() -> None:
    op.drop_column('messages', 'action_performed')
