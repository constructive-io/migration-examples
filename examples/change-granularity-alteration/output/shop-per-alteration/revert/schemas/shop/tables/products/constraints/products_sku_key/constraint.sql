-- Revert: schemas/shop/tables/products/constraints/products_sku_key/constraint


ALTER TABLE ONLY shop.products 
  DROP CONSTRAINT products_sku_key RESTRICT;


