"""fix_attendance_schema

Revision ID: c3d4e5f6g7h8
Revises: b2c3d4e5f6g7
Create Date: 2026-04-29 07:00:00.000000

"""
from typing import Sequence, Union
from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision: str = 'c3d4e5f6g7h8'
down_revision: Union[str, None] = 'b2c3d4e5f6g7'
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
    # 1. USERS - Ensure primary_account_uid is String
    # (Already added in previous migration as String, so just checking)

    # 2. ATTENDANCE - Fix columns
    if column_exists("attendance", "latitude") and not column_exists("attendance", "start_latitude"):
        op.alter_column("attendance", "latitude", new_column_name="start_latitude")
    
    if column_exists("attendance", "longitude") and not column_exists("attendance", "start_longitude"):
        op.alter_column("attendance", "longitude", new_column_name="start_longitude")

    if column_exists("attendance", "marked_at") and not column_exists("attendance", "start_at"):
        op.alter_column("attendance", "marked_at", new_column_name="start_at")

    if not column_exists("attendance", "end_at"):
        op.add_column("attendance", sa.Column("end_at", sa.DateTime(), nullable=True))

    if not column_exists("attendance", "user_uid"):
        op.add_column("attendance", sa.Column("user_uid", sa.String(), nullable=True))
        op.create_index(op.f("ix_attendance_user_uid"), "attendance", ["user_uid"], unique=False)

    if not column_exists("attendance", "company_uid"):
        op.add_column("attendance", sa.Column("company_uid", sa.String(), nullable=True))
        op.create_index(op.f("ix_attendance_company_uid"), "attendance", ["company_uid"], unique=False)

    if not column_exists("attendance", "end_latitude"):
        op.add_column("attendance", sa.Column("end_latitude", sa.Float(), nullable=True))

    if not column_exists("attendance", "end_longitude"):
        op.add_column("attendance", sa.Column("end_longitude", sa.Float(), nullable=True))

    if not column_exists("attendance", "work_hours"):
        op.add_column("attendance", sa.Column("work_hours", sa.Float(), nullable=True))

    if not column_exists("attendance", "start_address"):
        op.add_column("attendance", sa.Column("start_address", sa.String(), nullable=True))

    if not column_exists("attendance", "end_address"):
        op.add_column("attendance", sa.Column("end_address", sa.String(), nullable=True))

    if not column_exists("attendance", "status"):
        op.add_column("attendance", sa.Column("status", sa.String(), nullable=True, server_default="not started"))

    # Drop old columns
    if column_exists("attendance", "type"):
        op.drop_column("attendance", "type")


def downgrade() -> None:
    # This is a complex downgrade, but for dev let's just do basics
    op.add_column("attendance", sa.Column("type", sa.String(), nullable=True))
    
    op.drop_column("attendance", "status")
    op.drop_column("attendance", "end_address")
    op.drop_column("attendance", "start_address")
    op.drop_column("attendance", "work_hours")
    op.drop_column("attendance", "end_longitude")
    op.drop_column("attendance", "end_latitude")
    op.drop_index(op.f("ix_attendance_company_uid"), table_name="attendance")
    op.drop_column("attendance", "company_uid")
    op.drop_index(op.f("ix_attendance_user_uid"), table_name="attendance")
    op.drop_column("attendance", "user_uid")
    op.drop_column("attendance", "end_at")
    
    op.alter_column("attendance", "start_at", new_column_name="marked_at")
    op.alter_column("attendance", "start_longitude", new_column_name="longitude")
    op.alter_column("attendance", "start_latitude", new_column_name="latitude")
