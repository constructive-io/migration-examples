-- Deploy: schemas/shop/tables/orders/constraints/orders_status_check
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/orders/table


ALTER TABLE shop.orders 
  ADD CONSTRAINT orders_status_check 
    CHECK (status IN ('pending', 'paid', 'shipped', 'cancelled'));

