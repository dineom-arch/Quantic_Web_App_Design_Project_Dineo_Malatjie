"""Add featured menu items and collection checkout fields.

Revision ID: 8d2f6c7a91ab
Revises: c8a575308318
Create Date: 2026-07-26
"""
from alembic import op
import sqlalchemy as sa

revision = "8d2f6c7a91ab"
down_revision = "c8a575308318"
branch_labels = None
depends_on = None


def upgrade():
    op.add_column("menu_items", sa.Column("featured", sa.Boolean(), nullable=False, server_default=sa.false()))
    op.add_column("orders", sa.Column("customer_email", sa.String(length=128), nullable=True))
    op.add_column("orders", sa.Column("order_type", sa.String(length=20), nullable=False, server_default="collection"))
    op.add_column("orders", sa.Column("payment_method", sa.String(length=30), nullable=False, server_default="pay_on_collection"))
    op.add_column("orders", sa.Column("payment_status", sa.String(length=20), nullable=False, server_default="pending"))
    op.add_column("orders", sa.Column("collection_time", sa.DateTime(), nullable=True))
    op.add_column("orders", sa.Column("notes", sa.Text(), nullable=True))
    op.add_column("order_items", sa.Column("unit_price_cents", sa.Integer(), nullable=True))
    op.execute("""
        UPDATE order_items
        SET unit_price_cents = menu_items.price_cents
        FROM menu_items
        WHERE order_items.menu_item_id = menu_items.id
    """)
    op.alter_column("order_items", "unit_price_cents", nullable=False)
    op.create_unique_constraint("uq_order_item_menu", "order_items", ["order_id", "menu_item_id"])
    op.execute("""
        UPDATE orders
        SET customer_email = 'legacy-order-' || id || '@invalid.local'
        WHERE customer_email IS NULL
    """)
    op.alter_column("orders", "customer_email", nullable=False)


def downgrade():
    op.drop_constraint("uq_order_item_menu", "order_items", type_="unique")
    op.drop_column("order_items", "unit_price_cents")
    op.drop_column("orders", "notes")
    op.drop_column("orders", "collection_time")
    op.drop_column("orders", "payment_status")
    op.drop_column("orders", "payment_method")
    op.drop_column("orders", "order_type")
    op.drop_column("orders", "customer_email")
    op.drop_column("menu_items", "featured")
