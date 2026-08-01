-- Revert: schemas/shop/tables/order_items/columns/id/column


ALTER TABLE shop.order_items 
  DROP COLUMN id RESTRICT;


