-- Revert: schemas/shop/tables/orders/columns/status/column


ALTER TABLE shop.orders 
  DROP COLUMN status RESTRICT;


