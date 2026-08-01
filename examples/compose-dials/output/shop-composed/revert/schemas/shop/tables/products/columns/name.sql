-- Revert: schemas/shop/tables/products/columns/name


ALTER TABLE shop.products 
  DROP COLUMN name RESTRICT;


