-- Deploy: schemas/shop/tables/orders/columns/id/column
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/orders/table


ALTER TABLE shop.orders 
  ADD COLUMN id uuid
    DEFAULT gen_random_uuid()
    NOT NULL;

