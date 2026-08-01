-- Revert: schemas/shop/tables/products/table


REVOKE SELECT ON shop.products FROM app_user RESTRICT;

COMMENT ON TABLE shop.products IS NULL;

ALTER TABLE shop.products 
  DROP CONSTRAINT products_price_cents_check RESTRICT;

ALTER TABLE ONLY shop.products 
  DROP CONSTRAINT products_sku_key RESTRICT;

ALTER TABLE ONLY shop.products 
  DROP CONSTRAINT products_pkey RESTRICT;

ALTER TABLE shop.products 
  DROP COLUMN created_at RESTRICT;

ALTER TABLE shop.products 
  DROP COLUMN price_cents RESTRICT;

ALTER TABLE shop.products 
  DROP COLUMN description RESTRICT;

ALTER TABLE shop.products 
  DROP COLUMN name RESTRICT;

ALTER TABLE shop.products 
  DROP COLUMN sku RESTRICT;

ALTER TABLE shop.products 
  DROP COLUMN id RESTRICT;

DROP TABLE shop.products;


