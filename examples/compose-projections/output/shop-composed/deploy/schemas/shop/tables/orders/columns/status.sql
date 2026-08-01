-- Deploy: schemas/shop/tables/orders/columns/status
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/orders/table


ALTER TABLE shop.orders 
  ADD COLUMN status text
    DEFAULT 'pending'
    NOT NULL;

