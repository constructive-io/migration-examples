-- Deploy: schemas/shop/tables/orders/columns/placed_at
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/orders/table


ALTER TABLE shop.orders 
  ADD COLUMN placed_at timestamptz
    DEFAULT now()
    NOT NULL;

