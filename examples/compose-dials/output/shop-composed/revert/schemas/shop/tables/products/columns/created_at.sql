-- Revert: schemas/shop/tables/products/columns/created_at


ALTER TABLE shop.products 
  DROP COLUMN created_at RESTRICT;


