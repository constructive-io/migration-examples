-- Revert: schemas/shop/tables/orders/columns/status


ALTER TABLE shop.orders 
  DROP COLUMN status RESTRICT;


