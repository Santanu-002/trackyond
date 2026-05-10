"""add_started_at_to_job

Revision ID: cab52fc7abd3
Revises: beedaa4306b8
Create Date: 2026-05-10 14:18:31.730857

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = 'cab52fc7abd3'
down_revision: Union[str, None] = 'beedaa4306b8'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Create enum types (values must match core/constants/enums.py)
    attendancestatus = postgresql.ENUM('not started', 'working', 'ended', name='attendancestatus')
    attendancestatus.create(op.get_bind())
    jobstatus = postgresql.ENUM('pending', 'assigned', 'in_progress', 'completed', 'cancelled', name='jobstatus')
    jobstatus.create(op.get_bind())
    userrole = postgresql.ENUM('owner', 'worker', name='userrole')
    userrole.create(op.get_bind())

    # Alter columns with USING
    # Handle attendance status
    op.execute("ALTER TABLE attendance ALTER COLUMN status TYPE attendancestatus USING lower(status)::attendancestatus")
    
    op.add_column('jobs', sa.Column('started_at', sa.DateTime(), nullable=True))
    # Handle job status
    op.execute("ALTER TABLE jobs ALTER COLUMN status TYPE jobstatus USING lower(status)::jobstatus")
    
    # Handle user role: map 'employee' to 'worker' and 'admin' to 'owner'
    op.execute("UPDATE users SET role = 'worker' WHERE lower(role) = 'employee'")
    op.execute("UPDATE users SET role = 'owner' WHERE lower(role) = 'admin'")
    op.execute("ALTER TABLE users ALTER COLUMN role TYPE userrole USING lower(role)::userrole")


def downgrade() -> None:
    # Alter columns back to VARCHAR
    op.alter_column('users', 'role', type_=sa.VARCHAR(), existing_type=sa.Enum('owner', 'worker', name='userrole'), existing_nullable=True)
    op.alter_column('jobs', 'status', type_=sa.VARCHAR(), existing_type=sa.Enum('pending', 'assigned', 'in_progress', 'completed', 'cancelled', name='jobstatus'), existing_nullable=True)
    op.drop_column('jobs', 'started_at')
    op.alter_column('attendance', 'status', type_=sa.VARCHAR(), existing_type=sa.Enum('not started', 'working', 'ended', name='attendancestatus'), existing_nullable=True)

    # Drop enum types
    postgresql.ENUM(name='userrole').drop(op.get_bind())
    postgresql.ENUM(name='jobstatus').drop(op.get_bind())
    postgresql.ENUM(name='attendancestatus').drop(op.get_bind())
