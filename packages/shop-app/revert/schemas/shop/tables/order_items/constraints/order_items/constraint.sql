-- Revert: schemas/shop/tables/order_items/constraints/order_items/constraint


ALTER TABLE ONLY shop.order_items 
  DROP CONSTRAINT order_items_product_id_fkey RESTRICT;

ALTER TABLE ONLY shop.order_items 
  DROP CONSTRAINT order_items_order_id_fkey RESTRICT;


