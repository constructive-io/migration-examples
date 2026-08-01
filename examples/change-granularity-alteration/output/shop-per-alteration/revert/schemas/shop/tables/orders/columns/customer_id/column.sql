-- Revert: schemas/shop/tables/orders/columns/customer_id/column


ALTER TABLE shop.orders 
  DROP COLUMN customer_id RESTRICT;


