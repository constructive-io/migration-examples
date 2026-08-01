-- Deploy: schemas/shop/tables/order_items/columns/id/column
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/order_items/table


ALTER TABLE shop.order_items 
  ADD COLUMN id uuid
    DEFAULT gen_random_uuid()
    NOT NULL;

