-- Revert: schemas/shop/tables/order_items/columns/quantity


ALTER TABLE shop.order_items 
  DROP COLUMN quantity RESTRICT;


