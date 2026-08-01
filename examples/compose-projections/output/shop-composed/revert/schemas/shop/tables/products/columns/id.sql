-- Revert: schemas/shop/tables/products/columns/id


ALTER TABLE shop.products 
  DROP COLUMN id RESTRICT;


