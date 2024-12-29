"""add task date constraints

Revision ID: 239dbaf6423c
Revises: 9dacb9f9474f
Create Date: 2024-12-27 11:36:45.298242
"""

from alembic import op

# revision identifiers, used by Alembic.
revision = "239dbaf6423c"
down_revision = "9dacb9f9474f"
branch_labels = None
depends_on = None


def upgrade():
    # 1. First, clean up invalid data
    op.execute(
        """
        UPDATE tasks 
        SET end_at = NULL 
        WHERE 
            (start_at IS NULL AND end_at IS NOT NULL) OR  -- end_at without start_at
            (start_at IS NOT NULL AND end_at IS NOT NULL AND end_at <= start_at)  -- invalid date range
    """
    )

    # 2. Drop existing constraint if it exists
    op.execute("ALTER TABLE tasks DROP CONSTRAINT IF EXISTS check_task_dates")

    # 3. Add the new constraint
    op.execute(
        """
        ALTER TABLE tasks ADD CONSTRAINT check_task_dates 
        CHECK (
            (start_at IS NULL AND end_at IS NULL) OR 
            (start_at IS NOT NULL AND end_at IS NULL) OR 
            (start_at IS NOT NULL AND end_at IS NOT NULL AND end_at > start_at)
        )
    """
    )


def downgrade():
    op.execute("ALTER TABLE tasks DROP CONSTRAINT IF EXISTS check_task_dates")
