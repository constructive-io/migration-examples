-- Revert: schemas/shop/tables/orders/indexes/idx_orders_placed_at/drop


CREATE INDEX idx_orders_placed_at ON shop.orders (placed_at);


