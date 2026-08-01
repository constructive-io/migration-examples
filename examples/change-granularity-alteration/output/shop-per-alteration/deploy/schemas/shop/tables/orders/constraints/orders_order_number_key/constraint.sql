-- Deploy: schemas/shop/tables/orders/constraints/orders_order_number_key/constraint
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/orders/table
-- requires: schemas/shop/tables/orders/columns/order_number/column


ALTER TABLE ONLY shop.orders 
  ADD CONSTRAINT orders_order_number_key 
    UNIQUE (order_number);

