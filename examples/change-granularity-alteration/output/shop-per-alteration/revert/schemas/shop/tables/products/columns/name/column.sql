-- Revert: schemas/shop/tables/products/columns/name/column


ALTER TABLE shop.products 
  DROP COLUMN name RESTRICT;


