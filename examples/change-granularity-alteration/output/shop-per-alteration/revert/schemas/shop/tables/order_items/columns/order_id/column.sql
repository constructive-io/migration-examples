-- Revert: schemas/shop/tables/order_items/columns/order_id/column


ALTER TABLE shop.order_items 
  DROP COLUMN order_id RESTRICT;


