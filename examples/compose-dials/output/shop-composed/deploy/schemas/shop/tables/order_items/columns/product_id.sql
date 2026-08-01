-- Deploy: schemas/shop/tables/order_items/columns/product_id
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/order_items/table


ALTER TABLE shop.order_items 
  ADD COLUMN product_id uuid
    NOT NULL;

