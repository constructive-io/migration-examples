-- Deploy: schemas/shop/tables/orders/indexes/idx_orders_placed_at
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/orders/table
-- requires: schemas/shop/tables/orders/constraints/orders/constraint


CREATE INDEX idx_orders_placed_at ON shop.orders (placed_at);

