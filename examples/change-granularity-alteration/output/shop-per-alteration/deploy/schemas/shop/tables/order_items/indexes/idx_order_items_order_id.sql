-- Deploy: schemas/shop/tables/order_items/indexes/idx_order_items_order_id
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/order_items/constraints/order_items_product_id_fkey/constraint


CREATE INDEX idx_order_items_order_id ON shop.order_items (order_id);

