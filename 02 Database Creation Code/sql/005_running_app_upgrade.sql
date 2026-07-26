-- Café Fausse running application upgrade.
-- Prefer the matching Alembic migration in the top-level migrations folder.

BEGIN;

ALTER TABLE menu_items
    ADD COLUMN IF NOT EXISTS featured BOOLEAN NOT NULL DEFAULT FALSE;

ALTER TABLE orders
    ADD COLUMN IF NOT EXISTS customer_email VARCHAR(128),
    ADD COLUMN IF NOT EXISTS order_type VARCHAR(20) NOT NULL DEFAULT 'collection',
    ADD COLUMN IF NOT EXISTS payment_method VARCHAR(30) NOT NULL DEFAULT 'pay_on_collection',
    ADD COLUMN IF NOT EXISTS payment_status VARCHAR(20) NOT NULL DEFAULT 'pending',
    ADD COLUMN IF NOT EXISTS collection_time TIMESTAMP,
    ADD COLUMN IF NOT EXISTS notes TEXT;

ALTER TABLE order_items
    ADD COLUMN IF NOT EXISTS unit_price_cents INTEGER;

UPDATE order_items AS oi
SET unit_price_cents = mi.price_cents
FROM menu_items AS mi
WHERE oi.menu_item_id = mi.id
  AND oi.unit_price_cents IS NULL;

ALTER TABLE order_items
    ALTER COLUMN unit_price_cents SET NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uq_order_item_menu
    ON order_items(order_id, menu_item_id);

UPDATE orders
SET customer_email = 'legacy-order-' || id || '@invalid.local'
WHERE customer_email IS NULL;

ALTER TABLE orders
    ALTER COLUMN customer_email SET NOT NULL;

COMMIT;
