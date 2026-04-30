"""sync_schema_to_models

Revision ID: a1b2c3d4e5f6
Revises: 2c7253e8acff
Create Date: 2026-04-29 05:30:00.000000

This migration corrects schema drift between the actual database state
and the SQLAlchemy models. It handles:

  members table:
    - Rename uid -> account_uid
    - Rename uid index -> account_uid index
    - Add user_uid column + index + FK to users.uid
    - Add is_active column
    - Fix unique constraint (_user_company_uc) to use user_uid, company_uid

  jobs table:
    - Rename worker_uid -> worker_account_uid
    - Fix FK to reference members.account_uid

  users table:
    - Add primary_account_uid column

  attendance table:
    - Rename member_uid -> account_uid + fix FK to members.account_uid
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'a1b2c3d4e5f6'
down_revision: Union[str, None] = '2c7253e8acff'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def column_exists(table: str, column: str) -> bool:
    """Check if a column already exists in a table (safe guard for re-runs)."""
    from sqlalchemy import inspect, text
    from alembic import op as _op
    bind = op.get_bind()
    result = bind.execute(
        text(
            "SELECT 1 FROM information_schema.columns "
            "WHERE table_name=:t AND column_name=:c"
        ),
        {"t": table, "c": column},
    )
    return result.scalar() is not None


def constraint_exists(table: str, constraint: str) -> bool:
    """Check if a constraint exists on a table."""
    from sqlalchemy import text
    bind = op.get_bind()
    result = bind.execute(
        text(
            "SELECT 1 FROM information_schema.table_constraints "
            "WHERE table_name=:t AND constraint_name=:c"
        ),
        {"t": table, "c": constraint},
    )
    return result.scalar() is not None


def index_exists(index: str) -> bool:
    """Check if an index exists in the database (PostgreSQL)."""
    from sqlalchemy import text
    bind = op.get_bind()
    result = bind.execute(
        text(
            "SELECT 1 FROM pg_indexes WHERE indexname=:idx"
        ),
        {"idx": index},
    )
    return result.scalar() is not None


def upgrade() -> None:
    # ------------------------------------------------------------------ #
    # 1. USERS – add primary_account_uid                                  #
    # ------------------------------------------------------------------ #
    if not column_exists("users", "primary_account_uid"):
        op.add_column(
            "users",
            sa.Column("primary_account_uid", sa.String(), nullable=True),
        )

    # ------------------------------------------------------------------ #
    # 2. MEMBERS – rename uid -> account_uid                              #
    # ------------------------------------------------------------------ #
    # Drop old FK from attendance (member_uid -> users.uid) before we
    # rename; we recreate it at the end.
    # Drop old FK on members.uid -> users.uid (only if it exists)
    if constraint_exists("members", "members_uid_fkey"):
        op.drop_constraint("members_uid_fkey", "members", type_="foreignkey")

    # Drop old unique constraint that used uid column
    if constraint_exists("members", "_user_company_uc"):
        op.drop_constraint("_user_company_uc", "members", type_="unique")

    # Drop old index on uid
    if constraint_exists("members", "ix_members_uid"):
        op.drop_index("ix_members_uid", table_name="members")

    # Rename uid -> account_uid (only if uid column exists)
    if column_exists("members", "uid"):
        op.alter_column("members", "uid", new_column_name="account_uid")

    # Ensure account_uid column exists (create if it doesn't from uid rename or initial state)
    if not column_exists("members", "account_uid"):
        op.add_column(
            "members",
            sa.Column("account_uid", sa.String(), nullable=True),
        )

    # Recreate index for account_uid (unique – required for FK references)
    if not index_exists("ix_members_account_uid"):
        op.create_index(
            op.f("ix_members_account_uid"), "members", ["account_uid"], unique=False
        )

    # Add UNIQUE constraint on account_uid (needed by jobs + attendance FKs)
    if not constraint_exists("members", "uq_members_account_uid"):
        op.create_unique_constraint(
            "uq_members_account_uid", "members", ["account_uid"]
        )

    # ------------------------------------------------------------------ #
    # 3. MEMBERS – add user_uid column                                    #
    # ------------------------------------------------------------------ #
    if not column_exists("members", "user_uid"):
        op.add_column(
            "members",
            sa.Column("user_uid", sa.String(), nullable=True),
        )

    # Backfill user_uid from account_uid for any existing rows
    # (account_uid stored user uid before, so this is a safe copy)
    op.execute(
        "UPDATE members SET user_uid = account_uid WHERE user_uid IS NULL"
    )

    # Create FK: members.user_uid -> users.uid
    if not constraint_exists("members", "members_user_uid_fkey"):
        op.create_foreign_key(
            "members_user_uid_fkey", "members", "users", ["user_uid"], ["uid"]
        )

    # Create index on user_uid
    if not index_exists("ix_members_user_uid"):
        op.create_index(
            op.f("ix_members_user_uid"), "members", ["user_uid"], unique=False
        )

    # Recreate unique constraint with the correct columns
    if not constraint_exists("members", "_user_company_uc"):
        op.create_unique_constraint(
            "_user_company_uc", "members", ["user_uid", "company_uid"]
        )

    # ------------------------------------------------------------------ #
    # 4. MEMBERS – add is_active                                          #
    # ------------------------------------------------------------------ #
    if not column_exists("members", "is_active"):
        op.add_column(
            "members",
            sa.Column("is_active", sa.Boolean(), nullable=True, server_default="true"),
        )

    # ------------------------------------------------------------------ #
    # 5. JOBS – rename worker_uid -> worker_account_uid                   #
    # ------------------------------------------------------------------ #
    # Drop old FK (only if it exists)
    if constraint_exists("jobs", "jobs_worker_uid_fkey"):
        op.drop_constraint("jobs_worker_uid_fkey", "jobs", type_="foreignkey")

    # Rename column (only if worker_uid exists)
    if column_exists("jobs", "worker_uid"):
        op.alter_column("jobs", "worker_uid", new_column_name="worker_account_uid")

    # Ensure worker_account_uid column exists
    if not column_exists("jobs", "worker_account_uid"):
        op.add_column(
            "jobs",
            sa.Column("worker_account_uid", sa.String(), nullable=True),
        )

    # Recreate FK pointing to members.account_uid
    if not constraint_exists("jobs", "jobs_worker_account_uid_fkey"):
        op.create_foreign_key(
            "jobs_worker_account_uid_fkey",
            "jobs",
            "members",
            ["worker_account_uid"],
            ["account_uid"],
        )

    # ------------------------------------------------------------------ #
    # 6. ATTENDANCE – rename member_uid -> account_uid + fix FK           #
    # ------------------------------------------------------------------ #
    # Drop old FK (member_uid -> users.uid – was wrong target table)
    # Only if it exists
    if constraint_exists("attendance", "attendance_member_uid_fkey"):
        op.drop_constraint("attendance_member_uid_fkey", "attendance", type_="foreignkey")

    # Rename column (only if member_uid exists)
    if column_exists("attendance", "member_uid"):
        op.alter_column("attendance", "member_uid", new_column_name="account_uid")

    # Ensure account_uid column exists
    if not column_exists("attendance", "account_uid"):
        op.add_column(
            "attendance",
            sa.Column("account_uid", sa.String(), nullable=True),
        )

    # Create index on account_uid
    if not index_exists("ix_attendance_account_uid"):
        op.create_index(
            op.f("ix_attendance_account_uid"), "attendance", ["account_uid"], unique=False
        )

    # Recreate FK -> members.account_uid
    if not constraint_exists("attendance", "attendance_account_uid_fkey"):
        op.create_foreign_key(
            "attendance_account_uid_fkey",
            "attendance",
            "members",
            ["account_uid"],
            ["account_uid"],
        )


def downgrade() -> None:
    # ------------------------------------------------------------------ #
    # Reverse all changes in reverse order                                #
    # ------------------------------------------------------------------ #

    # 6. Attendance
    op.drop_constraint("attendance_account_uid_fkey", "attendance", type_="foreignkey")
    op.drop_index(op.f("ix_attendance_account_uid"), table_name="attendance")
    op.alter_column("attendance", "account_uid", new_column_name="member_uid")
    op.create_foreign_key(
        "attendance_member_uid_fkey", "attendance", "users", ["member_uid"], ["uid"]
    )

    # 5. Jobs
    op.drop_constraint("jobs_worker_account_uid_fkey", "jobs", type_="foreignkey")
    op.alter_column("jobs", "worker_account_uid", new_column_name="worker_uid")
    op.create_foreign_key(
        "jobs_worker_uid_fkey", "jobs", "users", ["worker_uid"], ["uid"]
    )

    # 4. Members is_active
    op.drop_column("members", "is_active")

    # 3. Members user_uid
    op.drop_constraint("_user_company_uc", "members", type_="unique")
    op.drop_index(op.f("ix_members_user_uid"), table_name="members")
    op.drop_constraint("members_user_uid_fkey", "members", type_="foreignkey")
    op.drop_column("members", "user_uid")

    # 2. Members rename account_uid -> uid
    op.drop_constraint("uq_members_account_uid", "members", type_="unique")
    op.drop_index(op.f("ix_members_account_uid"), table_name="members")
    op.alter_column("members", "account_uid", new_column_name="uid")
    op.create_index("ix_members_uid", "members", ["uid"], unique=False)
    op.create_foreign_key(
        "members_uid_fkey", "members", "users", ["uid"], ["uid"]
    )
    op.create_unique_constraint(
        "_user_company_uc", "members", ["uid", "company_uid"]
    )

    # 1. Users
    op.drop_column("users", "primary_account_uid")
