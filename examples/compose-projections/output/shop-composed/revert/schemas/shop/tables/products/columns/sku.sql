-- Revert: schemas/shop/tables/products/columns/sku


ALTER TABLE shop.products 
  DROP COLUMN sku RESTRICT;


