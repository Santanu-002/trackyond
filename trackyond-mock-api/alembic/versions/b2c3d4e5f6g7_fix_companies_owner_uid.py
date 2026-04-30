"""fix_companies_owner_uid

Revision ID: b2c3d4e5f6g7
Revises: a1b2c3d4e5f6
Create Date: 2026-04-29 06:10:00.000000

"""
from typing import Sequence, Union
from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision: str = 'b2c3d4e5f6g7'
down_revision: Union[str, None] = 'a1b2c3d4e5f6'
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
    # 1. Add owner_uid to companies
    if not column_exists("companies", "owner_uid"):
        op.add_column(
            "companies",
            sa.Column("owner_uid", sa.String(), sa.ForeignKey("users.uid"), nullable=True),
        )
        
        # Try to backfill owner_uid from user_phone_no if it exists
        if column_exists("companies", "user_phone_no"):
            op.execute(
                "UPDATE companies SET owner_uid = users.uid "
                "FROM users WHERE companies.user_phone_no = users.phone "
                "AND companies.owner_uid IS NULL"
            )
        
        # Make it unique as per model (if possible, but let's just make it nullable=False if we can)
        # For now, keep it nullable in case backfill didn't find everyone, 
        # but the model says nullable=False.
        # op.alter_column("companies", "owner_uid", nullable=False)
        op.create_unique_constraint("uq_companies_owner_uid", "companies", ["owner_uid"])

    # 2. Drop old columns if they exist
    if column_exists("companies", "user_phone_no"):
        op.drop_column("companies", "user_phone_no")
    if column_exists("companies", "user_full_name"):
        op.drop_column("companies", "user_full_name")


def downgrade() -> None:
    # Add back old columns
    op.add_column("companies", sa.Column("user_full_name", sa.String(), nullable=True))
    op.add_column("companies", sa.Column("user_phone_no", sa.String(), nullable=True))
    
    # Drop owner_uid
    op.drop_constraint("uq_companies_owner_uid", "companies", type_="unique")
    op.drop_column("companies", "owner_uid")
