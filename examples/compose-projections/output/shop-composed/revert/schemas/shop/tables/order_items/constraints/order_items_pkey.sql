-- Revert: schemas/shop/tables/order_items/constraints/order_items_pkey


ALTER TABLE ONLY shop.order_items 
  DROP CONSTRAINT order_items_pkey RESTRICT;


