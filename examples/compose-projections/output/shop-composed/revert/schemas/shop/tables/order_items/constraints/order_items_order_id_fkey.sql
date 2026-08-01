-- Revert: schemas/shop/tables/order_items/constraints/order_items_order_id_fkey


ALTER TABLE ONLY shop.order_items 
  DROP CONSTRAINT order_items_order_id_fkey RESTRICT;


