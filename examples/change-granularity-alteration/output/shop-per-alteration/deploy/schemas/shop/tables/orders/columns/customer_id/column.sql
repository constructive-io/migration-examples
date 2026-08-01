-- Deploy: schemas/shop/tables/orders/columns/customer_id/column
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/orders/table


ALTER TABLE shop.orders 
  ADD COLUMN customer_id uuid
    NOT NULL;

