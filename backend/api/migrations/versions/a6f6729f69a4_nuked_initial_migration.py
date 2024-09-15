"""Nuked initial migration

Revision ID: a6f6729f69a4
Revises: 
Create Date: 2024-09-08 20:18:42.808352

"""

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = "a6f6729f69a4"
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table("users", schema=None) as batch_op:
        batch_op.alter_column(
            "id", existing_type=sa.NUMERIC(), type_=sa.UUID(), existing_nullable=False
        )

    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table("users", schema=None) as batch_op:
        batch_op.alter_column(
            "id", existing_type=sa.UUID(), type_=sa.NUMERIC(), existing_nullable=False
        )

    # ### end Alembic commands ###
