-- Revert: schemas/shop/tables/orders/constraints/orders_status_check/constraint


ALTER TABLE shop.orders 
  DROP CONSTRAINT orders_status_check RESTRICT;


