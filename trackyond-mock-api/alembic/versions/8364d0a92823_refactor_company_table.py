"""refactor company table
Revision ID: 8364d0a92823
Revises: 08010c7b3ddc
Create Date: 2026-04-22 10:45:00.000000

"""
from typing import Sequence, Union
from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision: str = '8364d0a92823'
down_revision: Union[str, None] = '08010c7b3ddc'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # 1. Add owner_uid column (initially nullable if there are existing rows, then populated and set to not null)
    # But since this is a mock API and we want to apply it properly:
    op.add_column('companies', sa.Column('owner_uid', sa.String(), nullable=True))
    
    # 2. Add foreign key constraint
    op.create_foreign_key('fk_company_owner', 'companies', 'users', ['owner_uid'], ['uid'])
    
    # 3. Add unique constraint
    op.create_unique_constraint('uq_company_owner_uid', 'companies', ['owner_uid'])
    
    # 4. Drop old columns
    op.drop_column('companies', 'user_phone_no')
    op.drop_column('companies', 'user_full_name')
    
    # 5. Set owner_uid to non-nullable
    op.alter_column('companies', 'owner_uid', nullable=False)


def downgrade() -> None:
    # 1. Add old columns back
    op.add_column('companies', sa.Column('user_full_name', sa.String(), nullable=True))
    op.add_column('companies', sa.Column('user_phone_no', sa.String(), nullable=True))
    
    # 2. Drop unique constraint
    op.drop_constraint('uq_company_owner_uid', 'companies', type_='unique')
    
    # 3. Drop foreign key constraint
    op.drop_constraint('fk_company_owner', 'companies', type_='foreignkey')
    
    # 4. Drop owner_uid column
    op.drop_column('companies', 'owner_uid')
