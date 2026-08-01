-- Revert: schemas/shop/tables/products/constraints/products_pkey


ALTER TABLE ONLY shop.products 
  DROP CONSTRAINT products_pkey RESTRICT;


