-- Revert: schemas/shop/tables/orders/columns/customer_id


ALTER TABLE shop.orders 
  DROP COLUMN customer_id RESTRICT;


