-- Revert: schemas/shop/tables/orders/columns/order_number


ALTER TABLE shop.orders 
  DROP COLUMN order_number RESTRICT;


