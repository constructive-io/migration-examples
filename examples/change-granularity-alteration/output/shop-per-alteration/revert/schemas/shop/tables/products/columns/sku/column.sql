-- Revert: schemas/shop/tables/products/columns/sku/column


ALTER TABLE shop.products 
  DROP COLUMN sku RESTRICT;


