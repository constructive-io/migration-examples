-- Deploy: schemas/shop/tables/order_items/columns/quantity/column
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/order_items/table


ALTER TABLE shop.order_items 
  ADD COLUMN quantity int
    DEFAULT 1
    NOT NULL;

