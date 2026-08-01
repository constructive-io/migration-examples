-- Revert: schemas/shop/tables/order_items/constraints/order_items_product_id_fkey/constraint


REVOKE SELECT, INSERT ON shop.order_items FROM app_user RESTRICT;

ALTER TABLE ONLY shop.order_items 
  DROP CONSTRAINT order_items_product_id_fkey RESTRICT;


