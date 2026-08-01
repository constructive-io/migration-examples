-- Deploy: schemas/shop/tables/orders/columns/order_number/column
-- made with <3 @ constructive.io

-- requires: schemas/shop/schema
-- requires: schemas/shop/tables/orders/table
-- requires: schemas/shop/sequences/order_number_seq


ALTER TABLE shop.orders 
  ADD COLUMN order_number bigint
    DEFAULT nextval(CAST('shop.order_number_seq' AS regclass))
    NOT NULL;

