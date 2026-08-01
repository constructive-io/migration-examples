-- Revert: schemas/shop/tables/order_items/table


REVOKE SELECT, INSERT ON shop.order_items FROM app_user RESTRICT;

ALTER TABLE ONLY shop.order_items 
  DROP CONSTRAINT order_items_product_id_fkey RESTRICT;

ALTER TABLE ONLY shop.order_items 
  DROP CONSTRAINT order_items_order_id_fkey RESTRICT;

ALTER TABLE shop.order_items 
  DROP CONSTRAINT order_items_pkey RESTRICT;

ALTER TABLE shop.order_items 
  DROP COLUMN unit_price_cents RESTRICT;

ALTER TABLE shop.order_items 
  DROP COLUMN quantity RESTRICT;

ALTER TABLE shop.order_items 
  DROP COLUMN product_id RESTRICT;

ALTER TABLE shop.order_items 
  DROP COLUMN order_id RESTRICT;

ALTER TABLE shop.order_items 
  DROP COLUMN id RESTRICT;

DROP TABLE shop.order_items;


