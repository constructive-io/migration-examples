-- Revert: schemas/shop/tables/order_items/columns/order_id


ALTER TABLE shop.order_items 
  DROP COLUMN order_id RESTRICT;


