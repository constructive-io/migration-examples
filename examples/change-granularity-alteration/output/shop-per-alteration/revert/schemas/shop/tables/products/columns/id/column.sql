-- Revert: schemas/shop/tables/products/columns/id/column


ALTER TABLE shop.products 
  DROP COLUMN id RESTRICT;


