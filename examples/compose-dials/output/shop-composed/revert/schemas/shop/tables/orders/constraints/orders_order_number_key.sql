-- Revert: schemas/shop/tables/orders/constraints/orders_order_number_key


ALTER TABLE ONLY shop.orders 
  DROP CONSTRAINT orders_order_number_key RESTRICT;


