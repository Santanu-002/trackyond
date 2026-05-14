"""rename_account_uid_to_profile_uid_and_uid

Revision ID: 74bc8885be47
Revises: 95142f3caede
Create Date: 2026-05-14 10:40:16.106740

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '74bc8885be47'
down_revision: Union[str, None] = '95142f3caede'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # 1. Drop dependent foreign keys
    op.drop_constraint('attendance_account_uid_fkey', 'attendance', type_='foreignkey')
    op.drop_constraint('jobs_worker_account_uid_fkey', 'jobs', type_='foreignkey')

    # 2. Rename columns in 'members' and update index
    op.alter_column('members', 'account_uid', new_column_name='uid')
    op.drop_index('ix_members_account_uid', table_name='members')
    op.create_index(op.f('ix_members_uid'), 'members', ['uid'], unique=True)

    # 3. Rename columns in 'attendance' and recreate FK
    op.alter_column('attendance', 'account_uid', new_column_name='profile_uid')
    op.create_foreign_key('attendance_profile_uid_fkey', 'attendance', 'members', ['profile_uid'], ['uid'])
    
    # 4. Rename columns in 'jobs' and recreate FK
    op.alter_column('jobs', 'worker_account_uid', new_column_name='worker_profile_uid')
    op.create_foreign_key('jobs_worker_profile_uid_fkey', 'jobs', 'members', ['worker_profile_uid'], ['uid'])

    # 5. Rename columns in 'users'
    op.alter_column('users', 'primary_account_uid', new_column_name='primary_profile_uid')


def downgrade() -> None:
    op.drop_constraint('jobs_worker_profile_uid_fkey', 'jobs', type_='foreignkey')
    op.drop_constraint('attendance_profile_uid_fkey', 'attendance', type_='foreignkey')

    op.alter_column('users', 'primary_profile_uid', new_column_name='primary_account_uid')
    op.alter_column('jobs', 'worker_profile_uid', new_column_name='worker_account_uid')
    op.alter_column('attendance', 'profile_uid', new_column_name='account_uid')
    
    op.drop_index(op.f('ix_members_uid'), table_name='members')
    op.alter_column('members', 'uid', new_column_name='account_uid')
    op.create_index('ix_members_account_uid', 'members', ['account_uid'], unique=True)

    op.create_foreign_key('jobs_worker_account_uid_fkey', 'jobs', 'members', ['worker_account_uid'], ['account_uid'])
    op.create_foreign_key('attendance_account_uid_fkey', 'attendance', 'members', ['account_uid'], ['account_uid'])
