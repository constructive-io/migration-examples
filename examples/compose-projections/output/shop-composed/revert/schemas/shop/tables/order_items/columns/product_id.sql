-- Revert: schemas/shop/tables/order_items/columns/product_id


ALTER TABLE shop.order_items 
  DROP COLUMN product_id RESTRICT;


