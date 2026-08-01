-- Deploy: schemas/shop/tables/orders/indexes/idx_orders_customer_id
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/orders/table


CREATE INDEX idx_orders_customer_id ON shop.orders (customer_id);

