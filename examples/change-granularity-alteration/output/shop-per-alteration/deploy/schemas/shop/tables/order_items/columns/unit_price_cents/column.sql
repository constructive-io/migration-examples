-- Deploy: schemas/shop/tables/order_items/columns/unit_price_cents/column
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/order_items/table


ALTER TABLE shop.order_items 
  ADD COLUMN unit_price_cents int
    NOT NULL;

