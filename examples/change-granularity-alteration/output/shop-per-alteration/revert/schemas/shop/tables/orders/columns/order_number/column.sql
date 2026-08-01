-- Revert: schemas/shop/tables/orders/columns/order_number/column


ALTER TABLE shop.orders 
  DROP COLUMN order_number RESTRICT;


