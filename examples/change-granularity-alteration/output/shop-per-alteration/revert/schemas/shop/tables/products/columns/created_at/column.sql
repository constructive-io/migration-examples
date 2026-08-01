-- Revert: schemas/shop/tables/products/columns/created_at/column


ALTER TABLE shop.products 
  DROP COLUMN created_at RESTRICT;


