"""add_attendance_created_at

Revision ID: d4e5f6g7h8i9
Revises: c3d4e5f6g7h8
Create Date: 2026-04-30 18:00:00.000000

"""
from typing import Sequence, Union
from alembic import op
import sqlalchemy as sa
from sqlalchemy.sql import func

# revision identifiers, used by Alembic.
revision: str = 'd4e5f6g7h8i9'
down_revision: Union[str, None] = 'c3d4e5f6g7h8'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None

def column_exists(table: str, column: str) -> bool:
    from sqlalchemy import text
    bind = op.get_bind()
    result = bind.execute(
        text(
            "SELECT 1 FROM information_schema.columns "
            "WHERE table_name=:t AND column_name=:c"
        ),
        {"t": table, "c": column},
    )
    return result.scalar() is not None

def upgrade() -> None:
    if not column_exists("attendance", "created_at"):
        op.add_column("attendance", sa.Column("created_at", sa.DateTime(), nullable=True, server_default=func.now()))
    
    if not column_exists("attendance", "updated_at"):
        op.add_column("attendance", sa.Column("updated_at", sa.DateTime(), nullable=True, server_default=func.now()))

def downgrade() -> None:
    op.drop_column("attendance", "updated_at")
    op.drop_column("attendance", "created_at")
