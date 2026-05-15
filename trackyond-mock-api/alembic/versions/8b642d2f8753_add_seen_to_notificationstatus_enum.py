"""add seen to notificationstatus enum

Revision ID: 8b642d2f8753
Revises: c37e7c7baa04
Create Date: 2026-05-15 11:52:08.590970

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '8b642d2f8753'
down_revision: Union[str, None] = 'c37e7c7baa04'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Disable transaction to allow ALTER TYPE inside the migration
    with op.get_context().autocommit_block():
        op.execute("ALTER TYPE notificationstatus ADD VALUE IF NOT EXISTS 'seen'")


def downgrade() -> None:
    pass
