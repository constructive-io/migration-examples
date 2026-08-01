-- Revert: schemas/shop/tables/order_items/table


REVOKE SELECT, INSERT ON shop.order_items FROM app_user RESTRICT;

ALTER TABLE ONLY shop.order_items 
  DROP CONSTRAINT order_items_product_id_fkey RESTRICT;

ALTER TABLE ONLY shop.order_items 
  DROP CONSTRAINT order_items_order_id_fkey RESTRICT;

DROP TABLE shop.order_items;


