-- Revert: schemas/shop/tables/order_items/columns/product_id/column


ALTER TABLE shop.order_items 
  DROP COLUMN product_id RESTRICT;


